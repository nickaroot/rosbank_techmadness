//
//  RoundedButton.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 18/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

@IBDesignable

class RoundedButton: UIButton {
    
    // borderColor
    @IBInspectable public var borderColor: UIColor?{
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    // borderWidth
    @IBInspectable public var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    // cornerRadius
    @IBInspectable override public var cornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // shadowOpacity
    @IBInspectable public var shadowOpacity: Float = 0.0{
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    // shadowRadius
    @IBInspectable public var shadowRadius: CGFloat = 0{
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    
    // shadowColor
    @IBInspectable public var shadowColor: UIColor?{
        didSet{
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.adjustsFontForContentSizeCategory = true
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
