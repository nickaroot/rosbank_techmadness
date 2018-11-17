package handlers

import (
	"github.com/nickaroot/rosbank_techmadness/server/accessor"
	"github.com/nickaroot/rosbank_techmadness/server/ml_magic"
	"github.com/valyala/fasthttp"
	"net/http"
	"strconv"
)

type Env struct {
	accessor.Db
}

func (e *Env) SetPicture(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)
	index, err := strconv.Atoi(ctx.UserValue("index").(string))
	if err != nil {
		ctx.WriteString("Index must be string: " + err.Error())
		return
	}
	picture := ctx.Request.Body()

	err = e.Db.SetPicture(login, index, picture)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}

	return
}

func (e *Env) SetAssociativeWord(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)
	index, err := strconv.Atoi(ctx.UserValue("index").(string))
	if err != nil {
		ctx.WriteString("Index must be string: " + err.Error())
		return
	}
	keyword := string(ctx.Request.URI().QueryArgs().Peek("keyword"))
	if len(keyword) == 0 {
		ctx.WriteString("'кeyword' param must be specified")
		return
	}

	err = e.Db.SetAssociativeWord(login, index, keyword)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}

	return
}

func (e *Env) GetPicture(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)
	index, err := strconv.Atoi(ctx.UserValue("index").(string))
	if err != nil {
		ctx.WriteString("Index must be string: " + err.Error())
		return
	}

	picture, err := e.Db.GetPicture(login, index)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}

	ctx.SetBody(picture)
	return
}

func (e *Env) SetSpeechStandard(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)
	index, err := strconv.Atoi(ctx.UserValue("index").(string))
	if err != nil {
		ctx.WriteString("Index must be string: " + err.Error())
		return
	}
	speech := ctx.Request.Body()

	err = e.Db.SetSpeechStandard(login, index, speech)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}


	return
}

func (e *Env) CheckAssociationWord(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)
	index, err := strconv.Atoi(ctx.UserValue("index").(string))
	if err != nil {
		ctx.WriteString("Index must be string: " + err.Error())
		return
	}
	keyword := string(ctx.Request.URI().QueryArgs().Peek("keyword"))
	if len(keyword) == 0 {
		ctx.WriteString("'кeyword' param must be specified")
		return
	}

	match, err := e.Db.CheckAssociationWord(login, index, keyword)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}

	if match {
		ctx.Response.SetBody([]byte("true"))
	} else {
		ctx.Response.SetBody([]byte("false"))
	}
	return
}

func (e *Env) CheckSpeech(ctx *fasthttp.RequestCtx) {
	login := ctx.UserValue("login").(string)

	err, voiceSamples := e.Db.GetSpeech(login)
	if err != nil {
		ctx.WriteString("error in: " + accessor.FunctionName() + " : " + err.Error())
		ctx.Response.SetStatusCode(http.StatusInternalServerError)
		return
	}

	match, err := ml_magic.CompareVoise(voiceSamples, ctx.Request.Body())

	if match {
		ctx.Response.SetBody([]byte("true"))
	} else {
		ctx.Response.SetBody([]byte("false"))
	}
	return
}
