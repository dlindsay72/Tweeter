//
//  LoginVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-02-27.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notAMemberBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
        } else {
            
            self.view.resignFirstResponder()
            let username = usernameTextField.text!.lowercased()
            let password = passwordTextField.text!
            //send request to MYSQL database
            let url = URL(string: HostKey.login.rawValue)!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            let body = "username=\(username)&password=\(password)"
            request.httpBody = body.data(using:.utf8)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("error while parsing")
                            return
                        }
                        print("This is parseJSON: \(parseJSON)")
                        
                        let id = parseJSON["id"] as? String
                        
                        if id != nil {
                            // save user info we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            DispatchQueue.main.async(execute: {
                                appDelegate.login()
                            })
                        } else {
                            
                            DispatchQueue.main.async {
                                let message = parseJSON["message"] as! String
                                appDelegate.showInfoView(message: message, color: customOrange)
                                print("We got here...")
                            }
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            let message = error.localizedDescription
                            appDelegate.showInfoView(message: message, color: customOrange)
                            print("or we got here")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let message = error!.localizedDescription
                        appDelegate.showInfoView(message: message, color: customOrange)
                        print("maybe we ended up here")
                    }
                }
            }.resume()
            
        }
    }
    
    @IBAction func notAMemberBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordBtnWasPressed(_ sender: Any) {
        let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        present(resetPasswordVC, animated: true, completion: nil)
    }
    
    
}
