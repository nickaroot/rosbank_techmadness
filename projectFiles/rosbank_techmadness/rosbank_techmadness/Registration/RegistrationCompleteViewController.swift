//
//  RegistrationCompleteViewController.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

class RegistrationCompleteViewController: UIViewController {
    
    @IBOutlet weak var userwordLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pictureView: UIImageView!
    
    var userword: String!
    var wavData: Data!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        hideKeyboardWhenTappedAround()
        
        userwordLabel.text = userword
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userword = nil
    }
    
    @IBAction func doneTouchUpInside(_ sender: Any) {
        
        API.Registration.setPicture(login: "test", index: 0, picture: UIImage(named: "0")!) { (success) in
            print("SET PICTURE SUCCESS: \(success)")
            
            API.Registration.setSpeech(login: "test", index: 0, speech: self.wavData) { (success) in
                print("SET SPEECH SUCCESS: \(success)")
                
                API.Registration.setWord(login: "test", index: 0, word: self.userword) { (success) in
                    print("SET WORD SUCCESS: \(success)")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ShowLogin", sender: self)
                    }
                }
            }
        }
        
    }
    
    @IBAction func retryTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
