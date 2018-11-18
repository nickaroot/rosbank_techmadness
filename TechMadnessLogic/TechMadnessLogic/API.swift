//
//  API.swift
//  TechMadnessLogic
//
//  Created by Nikita Arutyunov on 17/11/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol APIResponse { }

class API {
    
    private static var domain: String = "http://10.42.0.1:8080"
    
    private static func getRequest(path: String,
                                  completionHandler: @escaping (_ success: Bool, _ response: Data?) -> Void) {
        
        let fullPath = "\(API.domain)\(path)".encodeUrl
        
        let url = URL(string: fullPath)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                
                completionHandler(false, nil)
                return
                
            }
            
            completionHandler(true, data)
            
        }
        
        task.resume()
        
    }
    
    private static func postRequest(path: String, data: Data?,
                                   completionHandler: @escaping (_ success: Bool, _ response: Data?) -> Void) {
        
        let fullPath = "\(API.domain)\(path)".encodeUrl
        
        let url = URL(string: fullPath)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completionHandler(false, nil)
                return
                
            }
            
            completionHandler(true, data)
            
        }
        
        task.resume()
        
    }
    
    class Registration {
        
        class func setPicture(login: String, index: Int, picture: UIImage,
                        completionHandler: @escaping (_ success: Bool) -> Void) {
            
            let path = "/api/registration_picture/\(login)/\(index)"
            
            print(path)
            
            API.postRequest(path: path, data: picture.pngData()) { (success, data) in
                completionHandler(success)
                
            }
            
        }
        
        class func setWord(login: String, index: Int, word: String,
                     completionHandler: @escaping (_ success: Bool) -> Void) {
            
            let path = "/api/association_word/\(login)/\(index)?keyword=\(word)"
            
            API.postRequest(path: path, data: nil) { (success, data) in
                completionHandler(success)
            }
            
        }
        
        class func setSpeech(login: String, index: Int, speech: Data,
                       completionHandler: @escaping (_ success: Bool) -> Void) {
            
            let path = "/api/speech_standard/\(login)/\(index)"
            
            API.postRequest(path: path, data: speech) { (success, data) in
                completionHandler(success)
                return
            }
            
            completionHandler(false)
            
        }
        
    }
    
    class Verification {
        
        class func getPicture(login: String, index: Int,
                        completionHandler: @escaping (_ success: Bool, _ picture: UIImage?) -> Void) {
            
            let path = "/api/registration_picture/\(login)/\(index)"
            
            API.getRequest(path: path) { (success, data) in
                
                guard let data = data else {
                    completionHandler(false, nil)
                    return
                }
                
                completionHandler(success, UIImage(data: data))
                
            }
            
            completionHandler(false, nil)
            
        }
        
        class func verifyWord(login: String, index: Int, word: String,
                        completionHandler: @escaping (_ success: Bool) -> Void) {
            
            let path = "/api/association_word_check/\(login)/\(index)?keyword=\(word)"
            
            API.postRequest(path: path, data: nil) { (success, data) in
                
                if success && data != nil {
                    let resp = String(data: data!, encoding: .utf8)
                    if resp == "true" {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                }
                else {
                    completionHandler(false)
                }
            }
            
        }
        
        class func verifySpeech(login: String, index: Int, speech: Data,
                          completionHandler: @escaping (_ success: Bool, _ speech: Data?) -> Void) {
            
            let path = "/api/speech_standard_check/\(login)"
            
            API.postRequest(path: path, data: speech) { (success, data) in
                
                if success && data != nil {
                    let resp = String(data: data!, encoding: .utf8)
                    if resp == "true" {
                        completionHandler(true, data)
                    }
                    else {
                        completionHandler(false, nil)
                    }
                }
                else {
                    completionHandler(false, nil)
                }
                
            }
            
        }
        
    }
    
}
