//
//  KeyboardDismissUIViewControllerExtension.swift
//  BBX4ALL
//
//  Created by Nick Arut on 27.04.2018.
//  Copyright © 2018 Nick Aroot. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        DispatchQueue.main.async {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func hideKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
