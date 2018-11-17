//
//  ViewController.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.Registration.setPicture(login: <#T##String#>, index: <#T##Int#>, picture: <#T##UIImage#>, completionHandler: <#T##(Bool) -> Void#>)
        API.Registration.setSpeech(login: <#T##String#>, index: <#T##Int#>, speech: <#T##Data#>, completionHandler: <#T##(Bool) -> Void#>)
        API.Registration.setWord(login: <#T##String#>, index: <#T##Int#>, word: <#T##String#>, completionHandler: <#T##(Bool) -> Void#>)
        
        API.Verification.getPicture(login: <#T##String#>, index: <#T##Int#>, completionHandler: <#T##(Bool, UIImage?) -> Void#>)
        API.Verification.verifySpeech(login: <#T##String#>, index: <#T##Int#>, speech: <#T##Data#>, completionHandler: <#T##(Bool, Data?) -> Void#>)
        API.Verification.verifyWord(login: <#T##String#>, index: <#T##Int#>, word: <#T##String#>, completionHandler: <#T##(Bool) -> Void#>)
        
    }


}

