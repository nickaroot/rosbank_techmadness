//
//  RegistrationViewController.swift
//  rosbank_techmadness
//
//  Created by Ибрагим on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cardView: UIView!
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            accountView.isHidden = true
            cardView.isHidden = false
        case 1:
            accountView.isHidden = false
            cardView.isHidden = true
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.isHidden = false
        accountView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
