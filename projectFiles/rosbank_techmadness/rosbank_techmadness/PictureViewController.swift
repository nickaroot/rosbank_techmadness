//
//  PictureViewController.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        recordButton.setImage(UIImage.init(named: "recordButtonRed"), for: .normal)
        recordButton.isHighlighted = false
    }
    
    @IBAction func recordButtonUpO(_ sender: UIButton) {
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

