//
//  RegistrationViewController.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit
import Speech

class RegistrationViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var recorder: AVAudioRecorder!
    var filePath: String!
    var wavData: Data!
    var association: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            
            var isButtonEnabled = false
            
            switch status {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
            case .restricted:
                isButtonEnabled = false
            case .notDetermined:
                isButtonEnabled = false
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
            
        }
        
    }
    
    
    @IBAction func recordTouchDown(_ sender: Any) {
        
        if !audioEngine.isRunning {
            
            let format = DateFormatter()
            format.dateFormat="yyyyMMddHHmmss"
            let audioFileName = "recording-\(format.string(from: Date())).wav"
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let pathArray = [dirPath, audioFileName]
            filePath = pathArray.joined(separator: "/")
            let fileURL = URL(string: filePath)
            
            let settings: [String: Any] = [AVAudioFileTypeKey: kAudioFileWAVEType]
            
            recorder = try! AVAudioRecorder(url: fileURL!, settings: settings)
            
            startRecording()
            recordButton.setTitle("Стоп", for: .normal)
            
        }
        
    }
    
    @IBAction func recordTouchUpInside(_ sender: Any) {
        
        if audioEngine.isRunning {
            
            audioEngine.stop()
            recorder.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Запись", for: .normal)
            
            wavData = FileManager.default.contents(atPath: filePath)
            
            if association != nil && association != "" {
                performSegue(withIdentifier: "ShowComplete", sender: self)
            }
            
        }
        
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setCategory(.record, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                let transcription = result?.bestTranscription.formattedString
                if transcription != nil {
                    let words = transcription!.split(separator: " ")
                    if words.count > 0 {
                        self.association = String(describing: words[0])
                    } else {
                        self.association = nil
                    }
                } else {
                    self.association = nil
                }
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                self.recorder.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowComplete" {
            
            let dest = segue.destination as! RegistrationCompleteViewController
            
            dest.userword = self.association
            dest.wavData = self.wavData
            
            self.association = nil
            self.wavData = nil
            
        }
        
    }
}

