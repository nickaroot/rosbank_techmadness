//
//  GradientButton.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 18/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

extension UIControl.State {
    static let loading = UIControl.State(rawValue: 1 << 16)
}

@IBDesignable class GradientButton: UIButton {
    
    var gradientLayer: CAGradientLayer!
    private var _angle = 180
    
    var savedTitle: String!
    var activityIndicator: UIActivityIndicatorView!
    
    
    var _style = ButtonStyle.clear
    
    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var angle: Int {
        set {
            self._angle = newValue
        }
        
        get {
            return self._angle
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    private var _loadingState: UInt = 0
    
    override var state: UIControl.State {
        return UIControl.State(rawValue: super.state.rawValue | self._loadingState)
    }
    
    var isLoading: Bool {
        get {
            return self._loadingState & UIControl.State.loading.rawValue == UIControl.State.loading.rawValue
        }
        
        set {
            if newValue == true {
                if (activityIndicator == nil) {
                    activityIndicator = createActivityIndicator()
                }
                
                savedTitle = currentTitle
                setTitle("", for: .loading)
                
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(activityIndicator)
                centerActivityIndicatorInButton()
                activityIndicator.startAnimating()
                
                self._loadingState |= UIControl.State.loading.rawValue
            } else {
                
                setTitle(savedTitle, for: .loading)
                
                activityIndicator.stopAnimating()
                
                self._loadingState &= ~UIControl.State.loading.rawValue
            }
        }
    }
    
    var style: ButtonStyle {
        set {
            _style = newValue
            layoutSubviews()
        }
        
        get {
            return _style
        }
    }
    
    func changeGradientStyle(to: ButtonStyle, textColor: UIColor, withDuration: TimeInterval) {
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.25).cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 4
        
        let gradientMask = CAShapeLayer()
        
        gradientMask.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        let gl = CAGradientLayer()
        
        gl.frame = bounds
        gl.cornerRadius = cornerRadius
        
        gl.colors = gradientColorStyles[to]
        gl.startPoint = startAndEndPointsFrom(angle: 0).startPoint
        gl.endPoint = startAndEndPointsFrom(angle: 0).endPoint
        //            gradientLayer.compositingFilter = "darkenBlendMode"
        //            gradientLayer.opacity = _gradientLayerOpacity
        
        gradientLayer = gl
        
        gradientLayer.opacity = 0
        
        layer.insertSublayer(gl, at: 0)
        
        //            layer.insertSublayer(shadowLayer, at: 0)
        
        UIView.animate(withDuration: withDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            
            self.gradientLayer.opacity = 1
            self.setTitleColor(textColor, for: .normal)
            
        })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer == nil && _style != .clear {
            
            let shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            
            shadowLayer.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.25).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 4
            
            let gradientMask = CAShapeLayer()
            
            gradientMask.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            
            let gl = CAGradientLayer()
            
            gl.frame = bounds
            gl.cornerRadius = cornerRadius
            
            gl.colors = gradientColorStyles[style]
            gl.startPoint = startAndEndPointsFrom(angle: _angle).startPoint
            gl.endPoint = startAndEndPointsFrom(angle: _angle).endPoint
            //            gradientLayer.compositingFilter = "darkenBlendMode"
            //            gradientLayer.opacity = _gradientLayerOpacity
            
            gradientLayer = gl
            
            layer.insertSublayer(gl, at: 0)
            
            //            layer.insertSublayer(shadowLayer, at: 0)
        } else if gradientLayer == nil {
            
            return
            
        } else if bounds != gradientLayer.bounds {
            
            let gl = CAGradientLayer()
            
            gl.frame = bounds
            gl.cornerRadius = cornerRadius
            
            gl.colors = gradientColorStyles[style]
            gl.startPoint = startAndEndPointsFrom(angle: _angle).startPoint
            gl.endPoint = startAndEndPointsFrom(angle: _angle).endPoint
            
            let oldGl = gradientLayer!
            gradientLayer = gl
            
            layer.replaceSublayer(oldGl, with: gl)
            
        }
    }
    
    override var isHighlighted: Bool {
        didSet { highlight(highlight: isHighlighted) }
    }
    
    private func highlight(highlight: Bool) {
        
        UIView.animate(
            withDuration: 0.65,
            delay: 0,
            usingSpringWithDamping: 0.325,
            initialSpringVelocity: 0.65,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.alpha = highlight ? 0.75 : 1 },
            completion: nil
        )
        
    }
    
}

