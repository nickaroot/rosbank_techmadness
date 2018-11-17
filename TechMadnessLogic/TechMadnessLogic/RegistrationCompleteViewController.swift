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
    
    var userword: String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        userwordTextField.text = userword
        
    }

    @IBAction func retryTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
