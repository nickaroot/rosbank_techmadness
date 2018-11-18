package ml_magic

import (
	"bytes"
	"fmt"
	"github.com/liuxp0827/govpr"
	"github.com/liuxp0827/govpr/log"
	"github.com/nickaroot/rosbank_techmadness/server/accessor"
	"github.com/pkg/errors"
	"io"
)

type engine struct {
	vprEngine *govpr.VPREngine
}

func NewEngine(sampleRate, delSilRange int, ubmFile, userModelFile string) (*engine, error) {
	vprEngine, err := govpr.NewVPREngine(sampleRate, delSilRange, false, ubmFile, userModelFile)
	if err != nil {
		return nil, err
	}
	return &engine{vprEngine: vprEngine}, nil
}

func (this *engine) DestroyEngine() {
	this.vprEngine = nil
}

func (this *engine) TrainSpeech(buffers [][]byte) error {

	var err error
	count := len(buffers)
	for i := 0; i < count; i++ {
		err = this.vprEngine.AddTrainBuffer(buffers[i])
		if err != nil {
			log.Error(err)
			return err
		}
	}

	defer this.vprEngine.ClearTrainBuffer()
	defer this.vprEngine.ClearAllBuffer()

	err = this.vprEngine.TrainModel()
	if err != nil {
		log.Error(err)
		return err
	}

	return nil
}

func (this *engine) RecSpeech(buffer []byte) (float64, error) {

	err := this.vprEngine.AddVerifyBuffer(buffer)
	defer this.vprEngine.ClearVerifyBuffer()
	if err != nil {
		log.Error(err)
		return -1.0, err
	}

	err = this.vprEngine.VerifyModel()
	if err != nil {
		log.Error(err)
		return -1.0, err
	}

	return this.vprEngine.GetScore(), nil
}

func WaveLoad(r io.Reader) ([]byte, error) {
	var err error
	var header [44]byte
	var iTotalReaded int
	var lengthOfData uint32
	var wavData []byte
	cBuff := make([]byte, 0x4000)
	bufsum := header[:44]

	_, err = r.Read(bufsum)
	if err != nil {
		return nil, err
	}

	if bufsum[0] != 'R' || bufsum[1] != 'I' || bufsum[2] != 'F' || bufsum[3] != 'F' {
		return nil, fmt.Errorf("invalid wave haeder")
	}

	if bufsum[22] != 1 || bufsum[23] != 0 {
		return nil, fmt.Errorf("this wave channel is not 1")
	}

	lengthOfData = uint32(bufsum[40])
	lengthOfData |= uint32(bufsum[41]) << 8
	lengthOfData |= uint32(bufsum[42]) << 16
	lengthOfData |= uint32(bufsum[43]) << 24
	if lengthOfData <= 0 {
		return nil, fmt.Errorf("length of wave data is 0")
	}

	for {
		iBytesReaded, err := r.Read(cBuff)
		if err != nil || iTotalReaded >= int(lengthOfData) {
			break
		}
		iTotalReaded += iBytesReaded
		if iTotalReaded >= int(lengthOfData) {
			iBytesReaded = iBytesReaded - (iTotalReaded - int(lengthOfData))
		}

		wavData = append(wavData, cBuff[:iBytesReaded]...)
	}

	return wavData, nil
}

func CompareVoise(referenceValues [][]byte, checkedValue []byte) (match bool, err error){
	vprEngine, err := NewEngine(16000, 50, "./ml_magic/model/ubm/ubm", "./ml_magic/model/test.dat")
	if err != nil {
		err = errors.Wrap(err, "in " + accessor.FunctionName())
		log.Error(err)
		return
	}

	for i, value := range referenceValues {
		referenceValues[i] = value[44:]	// remove .wav header info 44 bits
	}

	err = vprEngine.TrainSpeech(referenceValues)
	if err != nil {
		err = errors.Wrap(err, "in " + accessor.FunctionName())
		log.Error(err)
		return
	}

	var threshold = 0.8

	selfVerifyBuffer, err := WaveLoad(bytes.NewReader(checkedValue))
	if err != nil {
		err = errors.Wrap(err, "in " + accessor.FunctionName())
		log.Error(err)
		return
	}

	selfScore, err := vprEngine.RecSpeech(selfVerifyBuffer)
	if err != nil {
		err = errors.Wrap(err, "in " + accessor.FunctionName())
		log.Error(err)
		return
	}

	match = selfScore >= threshold
	log.Infof("self score %f, pass? %v", selfScore, match)

	return
}
