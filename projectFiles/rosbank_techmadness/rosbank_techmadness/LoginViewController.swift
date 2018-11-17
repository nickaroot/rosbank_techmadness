//
//  LoginViewCintroller.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EntryNav: UINavigationItem!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwTextField: UITextField!
    
    @IBAction func loginButtomAction(_ sender: Any) {
        
        if checkStatus(){
            self.performSegue(withIdentifier: "entrySegue", sender: nil)
        } else{
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Ошибка при вводе логина/пароля!", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func checkStatus()->Bool{
        return (validPassword() && validLogin())
    }
    
    func validPassword()->Bool{
        if (passwTextField.text!.count>3){
            return true
        }else{
            return false
        }
       
    }
    
    func validLogin()->Bool{
        if (loginTextField.text!.count>3){
            return true
        }
        else{
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.red
    }

}

