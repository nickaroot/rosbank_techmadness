//
//  MainViewController.swift
//  rosbank_techmadness
//
//  Created by Ибрагим on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        changeloginButtonImage()
    }
    
    

    func changeloginButtonImage(){
        loginButton.setImage(UIImage(named: "loginButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
}
