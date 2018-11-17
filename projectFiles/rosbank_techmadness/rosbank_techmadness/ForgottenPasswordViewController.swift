//
//  ForgottenPasswordViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//


import UIKit

class ForgottenPasswordViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var CardRecovery: UIView!
    @IBOutlet weak var AccountRecivery: UIView!
    @IBOutlet weak var PictureRecovery: UIView!
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            CardRecovery.isHidden = false
            AccountRecivery.isHidden = true
            PictureRecovery.isHidden = true
        case 1:
            CardRecovery.isHidden = true
            AccountRecivery.isHidden = false
            PictureRecovery.isHidden = true
        case 2:
            CardRecovery.isHidden = true
            AccountRecivery.isHidden = true
            PictureRecovery.isHidden = false
        default:
            break
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CardRecovery.isHidden = false
        AccountRecivery.isHidden = true
        PictureRecovery.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

