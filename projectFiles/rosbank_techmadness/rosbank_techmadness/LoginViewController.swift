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
    
    var entryCounts = 0
    
    
    @IBAction func loginButtomAction(_ sender: Any) {
        if checkStatus(){
            entryCounts = entryCounts + 1
            self.performSegue(withIdentifier: "entrySegue", sender: nil)
            reminderAlert()
            loginTextField.text = ""
            passwTextField.text = ""
        } else{
                let alertController = UIAlertController(title: "Ошибка при вводе логина/пароля!", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
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
        
        addNavBarImage()
    }
    
    func addNavBarImage(){
        
        let navController = navigationController!
        navController.navigationBar.barTintColor = UIColor.white
        let image = UIImage(named: "launchScreenEmblem")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image!.size.width / 2
        let bannerY = bannerHeight / 2 - image!.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    func reminderAlert()->Void{
        
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

