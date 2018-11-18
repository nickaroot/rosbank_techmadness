//
//  PictureView.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 18/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

@IBDesignable class PictureView: UIImageView {
    
    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
}
