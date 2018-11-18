//
//  ReminderCompleteViewController.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

class ReminderCompleteViewController: UIViewController {
    
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
        
        API.Verification.getPicture(login: "test", index: 0) { (success, image) in
            
            DispatchQueue.main.async {
                self.pictureView.image = image
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userword = nil
    }
    
    @IBAction func doneTouchUpInside(_ sender: Any) {
        
        API.Verification.verifySpeech(login: "test", index: 0, speech: wavData) { (success) in
            print("VERIFY SPEECH SUCCESS: \(success)")
            
            API.Verification.verifyWord(login: "test", index: 0, word: self.userword, completionHandler: { (success) in
                print("VERIFY WORD SUCCESS: \(success)")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Успешно", message: "Ассоциация подтверждена", preferredStyle: .alert)
                    
                    let acceptAction = UIAlertAction(title: "Далее", style: .default, handler: { [weak alert] (_) in
                        self.performSegue(withIdentifier: "ShowLogin", sender: self)
                        //self.navigationController?.popViewController(animated: true)
                    })
                    
                    alert.addAction(acceptAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @IBAction func retryTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
