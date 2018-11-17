package accessor

import (
	"database/sql"
	"fmt"
	"github.com/pkg/errors"
	"runtime"
)

func FunctionName() (str string) {
	pc := make([]uintptr, 15)
	n := runtime.Callers(2, pc)
	frames := runtime.CallersFrames(pc[:n])
	frame, _ := frames.Next()
	return fmt.Sprintf("%s:%d %s", frame.File, frame.Line, frame.Function)
}

// привязываем логику к этой надстройке над коннектором.
type Db struct {
	sql.DB
}

func (db *Db) InitTables() (err error) {
	// language=PostgreSQL
	sql := `
start transaction isolation level serializable;
create table if not exists "registration_picture"(
    "login" text not null,
	"index" integer not null,
    "picture" bytea not null,
	"association_word" text
);

create unique index if not exists "registration_picture_pk" on "registration_picture"("login", "index"); 

create table if not exists "speech" (
    "login" text not null,
    "index" integer not null,
    "sound_recording" bytea not null
);

create unique index if not exists "speech_pk" on "speech"("login", "index");
commit;
`
	_, err = db.Exec(sql)
	if err != err {
		err = errors.New("error in " + FunctionName() + err.Error())
	}
	return
}

// Установка картинки асоциации для залогиненного пользователя
// POST
// /api/registration_picture/:login/:index
// в теле запроса картинка.
func (db *Db) SetPicture(login string, index int, picture []byte) (err error) {
	// language=PostgreSQL
	sql := `
insert into "registration_picture"(
    "login",
	"index",
    "picture"
) values (
    $1, $2, $3
) on conflict do update set 
	"picture" = $3
where
    "login" = $1 &&
	"index" = $2
;`
	_, err = db.Exec(sql, login, index, picture)
	if err != err {
		err = errors.New("error in " + FunctionName() + err.Error())
	}
	return
}

// Установка слова для картинки асоциации.
// POST
// /api/association_word/:login/:index?keyword=""
func (db *Db) SetAssociativeWord(login string, index int, associativeWord string) (err error) {
	// language=PostgreSQL
	sql := `
update 
    "registration_picture"
set 
    "association_word" = $3
where
    "login" = $1 &&
	"index" = $2
;`
	result, err := db.Exec(sql, login, index, associativeWord)
	if err != nil {
		err = errors.Wrap(err, "in function: "+FunctionName())
		return
	}
	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		err = errors.New("not found")
	}
	return
}

// Установка эталонного обрезка речи для человека.
// POST
// /api/speech_standard/:login/:index
// В теле запись в.wav формате.
func (db *Db) SetSpeechStandard(login string, index int, speech []byte) (err error) {
	// language=PostgreSQL
	sql := `
insert into "speech" (
    "login",
    "index",
    "sound_recording"
) values (
    $1, $2, $3
) on conflict do update set 
    "sound_recording" = $3
where 
	"login" = $1 &&
    "index" = $2
;`
	_, err = db.Exec(sql, login, index, speech)
	if err != nil {
		err = errors.Wrap(err, "in function "+FunctionName())
	}
	return
}

// Запрос картинки для отображения.
// GET
// /api/registration_picture/:login/:index
// В теле ответа - картинка, как прислали при установке, без изменений.
func (db *Db) GetPicture(login string, index int) (picture []byte, err error) {
	// language=PostgreSQL
	sql := `
select
    "picture"
from
    "registration_picture"
where 
    "login" = $1 &&
    "index" = $2
;`
	err = db.QueryRow(sql, login, index).Scan(&picture)
	if err != nil {
		errors.Wrap(err, "in function "+FunctionName())
	}
	return
}

// Запрос валидности слова/асоциации.
// POST
// /api/association_word/:login/:index?keyword=""
func (db *Db) CheckAssociationWord(login string, index int, associationWord string) (match bool, err error) {
	// language=PostgreSQL
	sql := `
select
    "association_word"
from
    "registration_picture"
where
    "login" = $1 &&
	"index" = $2
;`
	realAssociationWord := ""
	err = db.QueryRow(sql, login, index).Scan(&realAssociationWord)
	if err != nil {
		errors.Wrap(err, "in function "+FunctionName())
	}

	match = associationWord == realAssociationWord
	return
}

// Запрос валидности речи по файлику речи
// POST
// /api/speech_standard/:login/:index
// В теле запись в .wav формате.
// Самая сложная часть, используем пакет "github.com/liuxp0827/govpr"
// просто компиляция из /github.com/liuxp0827/govpr/example/main.go
func (db *Db) GetSpeech(login string) (err error, voiceSamples [][]byte) {
	// language=PostgreSQL
	sql := `
select
    "sound_recording"
from
    "speech"
where
    "login" = $1
;`
    rows, err := db.Query(sql, login)
	if err != nil {
		return
	}
    defer rows.Close()
    for rows.Next() {
		var voiceSample []byte
    	err = rows.Scan(&voiceSample)
    	if err != nil {
    		return
		}
		voiceSamples = append(voiceSamples, voiceSample)
	}
    err = rows.Err()
    return
}
