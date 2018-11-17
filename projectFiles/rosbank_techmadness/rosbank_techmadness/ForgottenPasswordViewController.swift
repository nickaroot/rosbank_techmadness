//
//  ForgottenPasswordViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//


import UIKit

class ForgottenPasswordViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex{
        case 0:
            myLabel.text = "Женя пидр"
        case 1:
            myLabel.text = "Женя очень пидр"
        case 2:
            myLabel.text = "Женя очень очень пидр"
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

