//
//  ReminderViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    

    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var recordButton: UIButton!
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
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButton"), for: .normal)
        recordButton.isHighlighted = false
    }
    
    @IBAction func recordButtonDown(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButtonRed"), for: .normal)
        recordButton.isHighlighted = false
    }
    
    @IBAction func recordButtonTouchUp(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButton"), for: .normal)
        recordButton.isHighlighted = false
    }
    @IBAction func recordButtonDragInside(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButtonRed"), for: .normal)
        recordButton.isHighlighted = false
    }
    
    @IBAction func recordButtonDragOut(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButtonRed"), for: .normal)
        recordButton.isHighlighted = false
    }
}

