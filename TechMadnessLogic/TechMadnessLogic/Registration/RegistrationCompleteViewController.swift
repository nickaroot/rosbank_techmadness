//
//  RegistrationCompleteViewController.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

class RegistrationCompleteViewController: UIViewController {
    
    @IBOutlet weak var userwordTextField: UITextField!
    @IBOutlet weak var doneButton: GradientButton!
    @IBOutlet weak var pictureView: UIImageView!
    
    var userword: String!
    var wavData: Data!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        doneButton.style = .new
        doneButton.angle = 170
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        userwordTextField.text = userword
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userword = nil
    }

    @IBAction func retryTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func reqTest(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let url = URL(string: "http://10.42.0.1:8080/api/registration_picture/test/0")!
        var request = URLRequest(url: url)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        request.httpBody = nil
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                
                completionHandler(false)
                
                return
            }
            
            completionHandler(true)
            
        }
        
        task.resume()
        
    }
    
    @IBAction func doneTouchUpInside(_ sender: Any) {
        print("=== TEST ===")
//        API.Registration.setPicture(login: "test", index: 0, picture: UIImage(named: "inter-bosh-1")!) { (success) in
//            print("SET PICTURE SUCCESS: \(success)")
//
//            API.Verification.getPicture(login: "test", index: 0) { (success, image) in
//                print("GET PICTURE SUCCESS: \(success)\nIMAGE: \(image)")
//                DispatchQueue.main.async {
//                    self.pictureView.image = image
//                }
//            }
//
//        }
//
//        API.Registration.setWord(login: "test", index: 0, word: userword) { (success) in
//            print("SET WORD SUCCESS: \(success)")
//
//            API.Verification.verifyWord(login: "test", index: 0, word: self.userword) { (success) in
//                print("VERIFY WORD SUCCESS: \(success)")
//            }
//            
//        }
        
//        API.Registration.setSpeech(login: "test", index: 0, speech: wavData) { (success) in
//            print("SET SPEECH SUCCESS: \(success)")
//        }
        
        API.Verification.verifySpeech(login: "test", index: 0, speech: wavData) { (success, data) in
            print("VERIFY SPEECH SUCCESS: \(success)")
        }
        
    }
}
