package main

import (
	"database/sql"
	"github.com/buaazp/fasthttprouter"
	"github.com/valyala/fasthttp"
	"log"
	_ "github.com/lib/pq"

	"github.com/nickaroot/rosbank_techmadness/server/accessor"
	"github.com/nickaroot/rosbank_techmadness/server/handlers"
)

func main() {
	// Установка соединения к базе.
	_db, err := sql.Open("postgres", "postgres://postgres:@localhost/password_change?sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	env := handlers.Env{
		Db: accessor.Db{DB: *_db},
	}
	err = env.Db.InitTables()
	if err != nil {
		log.Fatal(err)
	}

	router := fasthttprouter.New()
	// Установка картинки асоциации для залогиненного пользователя
	router.POST("/api/registration_picture/:login/:index", env.SetPicture)
	// Установка слова для картинки асоциации
	router.POST("/api/association_word/:login/:index", env.SetAssociativeWord)
	// Установка эталонного обрезка речи для человека
	router.POST("/api/speech_standard/:login/:index", env.SetSpeechStandard)
	// Запрос картинки для отображения
	router.GET ("/api/registration_picture/:login/:index", env.GetPicture)
	// Запрос валидности слова/асоциации.
	router.POST("/api/association_word_check/:login/:index", env.CheckAssociationWord)
	// Запрос валидности речи по файлику речи
	router.POST("/api/speech_standard_check/:login", env.CheckSpeech)
	log.Print("Start listening in at http://[::1]:8080")
	log.Fatal(fasthttp.ListenAndServe(":8080", router.Handler))
}
