//
//  RecoveryViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class RecoveryViewController: UIViewController {
    

    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            passView.isHidden = false
            loginView.isHidden = true
        case 1:
            passView.isHidden = true
            loginView.isHidden = false
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        hideKeyboardWhenTappedAround()
        
    }
}

