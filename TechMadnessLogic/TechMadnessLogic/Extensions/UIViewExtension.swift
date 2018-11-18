//
//  UIViewExtension.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 18/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

enum ButtonStyle {
    case blue, new, clear
}

let gradientColorStyles: [ButtonStyle: [CGColor]] = [
    .blue: [ UIColor(red: 0.05, green: 0.43, blue: 1.0, alpha: 1).cgColor, UIColor(red: 0.17, green: 0.7, blue: 1.0, alpha: 1).cgColor ],
    .new: [ UIColor(red: 1, green: 0.48, blue: 0.0, alpha: 1).cgColor, UIColor(red: 1.0, green: 0.0, blue: 0.48, alpha: 1).cgColor ],
    .clear: [ UIColor.clear.cgColor, UIColor.clear.cgColor ]
]

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}
