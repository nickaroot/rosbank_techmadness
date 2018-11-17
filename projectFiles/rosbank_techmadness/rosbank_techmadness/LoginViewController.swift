//
//  LoginViewCintroller.swift
//  rosbank_techmadness
//
//  Created by Юрий Шашкин on 17/11/2018.
//  Copyright © 2018 Ибрагим Мамадаев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var entryNum: Int = 0
    
    @IBOutlet weak var EntryNav: UINavigationItem!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwTextField: UITextField!
    
    @IBAction func loginButtomAction(_ sender: Any) {
        
        if checkStatus(){
            self.performSegue(withIdentifier: "entrySegue", sender: nil)
            entryNum = entryNum + 1
            reminder()
            
        } else{
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Не введено поле логин/пароль", message: "", preferredStyle: UIAlertController.Style.alert)
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
    
    func reminder()->Void{
        if (Float(entryNum) / 1 == 1.0){
            entryNum = 0
            DispatchQueue.main.async {
//                let alertController = UIAlertController(title: "Хотите вспонить ассоциацию?", message: "", preferredStyle: UIAlertController.Style.alert)
//                alertController.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default,handler: nil))
////                 alertController.addAction(UIAlertAction(title: "Позднее", style: UIAlertAction.Style.default,handler: nil))
//                self.present(alertController, animated: true, completion: nil)
                
                let alert = UIAlertController(title: "Success", message: "You are validated!", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "Да", style: .default, handler: {action in
                    self.performSegue(withIdentifier: "reminderSegue", sender: nil);
                })
                alert.addAction(defaultAction)
                alert.addAction(UIAlertAction(title: "Позднее", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
//                let defaultAction = UIAlertAction(title: "Да", style: .default, handler: {action in
//                    self.performSegue(withIdentifier: "reminderSegue", sender: nil);
//                })
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.red
    }

}

