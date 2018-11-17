//
//  PictureViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit
import Speech

class PictureViewController: UIViewController {
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngene = AVAudioEngine()
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if audioEngene.isRunning {
            audioEngene.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Начать запись", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Остановить запись", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false // 1
        
        speechRecognizer?.delegate = self // 2
        
        SFSpeechRecognizer.requestAuthorization { // 3
            status in
            
            var buttonState = false // 4
            
            switch status { // 5
            case .authorized:
                buttonState = true
                print("Разрешение получено")
            case .denied:
                buttonState = false
                print("Пользователь не дал разрешения на использование распознавания речи")
            case .notDetermined:
                buttonState = false
                print("Распознавание речи еще не разрешено пользователем")
            case .restricted:
                buttonState = false
                print("Распознавание речи не поддерживается на этом устройстве")
            }
            
            DispatchQueue.main.async { // 6
                self.recordButton.isEnabled = buttonState // 7
            }
            
            
        }
        
    }
    
    
    func startRecording() {
        
        if recognitionTask != nil {  // 1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance() // 2
        
        do { // 3
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Не удалось настроить аудиосессию")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() // 4
        
        let inputNode = audioEngene.inputNode
        
        guard let recognitionRequest = recognitionRequest else { // 6
            fatalError("Не могу создать экземпляр запроса")
        }
        
        recognitionRequest.shouldReportPartialResults = true // 7
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { // 8
            result, error in
            
            var isFinal = false // 9
            
            if result != nil { // 10
                self.textField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal { // 11
                self.audioEngene.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
            
        }
        
        
        let format = inputNode.outputFormat(forBus: 0) // 12
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { // 13
            buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngene.prepare() //14
        
        do {  // 15
            try audioEngene.start()
        } catch {
            print("Не удается стартонуть движок")
        }
        
        textField.text = "Помедленнее... Я записую...." // 16
    }
    
}

extension PictureViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
}

