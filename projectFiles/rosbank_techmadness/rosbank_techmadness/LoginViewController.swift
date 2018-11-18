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
        var entryCounts = 0
        if checkStatus(){
            entryCounts = entryCounts + 1
            self.performSegue(withIdentifier: "entrySegue", sender: nil)
            reminderAlert()
            loginTextField.text = ""
            passwTextField.text = ""
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
    
    func reminderAlert()->Void{
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Мера безопасности", message: "Хотите вспомнить ассоциацию?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Да", style: .default, handler: {action in
                switch action.style {
                case .default:
                    self.performSegue(withIdentifier: "reminderSegue", sender: nil);
                case .cancel:
                    print("Cancel")
                case .destructive:
                    print("Destructive")
                }
            })
            alert.addAction(defaultAction)
            alert.addAction(UIAlertAction(title: "Позже", style: .default,handler: nil))
            self.present(alert, animated: true, completion: nil)
       }
        
    }
}

