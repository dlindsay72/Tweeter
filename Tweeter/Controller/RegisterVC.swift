//
//  RegisterVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-02-27.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var toLoginScreenBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }

    @IBAction func registerBtnTapped(_ sender: Any) {
        if usernameTxtField.text!.isEmpty || passwordTxtField.text!.isEmpty || emailTxtField.text!.isEmpty || firstNameTxtField.text!.isEmpty || lastNameTxtField.text!.isEmpty {
            usernameTxtField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            emailTxtField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            passwordTxtField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            firstNameTxtField.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            lastNameTxtField.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
        } else {
            self.view.endEditing(true)
            // create new user in MySql
            // url to php fle
            let url = URL(string: HostKey.register.rawValue)!
            //request to this file
            var request = URLRequest(url: url)
            //method to pass data to this file
            request.httpMethod = "POST"
            
            guard let usernameTxt = usernameTxtField.text?.lowercased(), let passwordTxt = passwordTxtField.text, let emailTxt = emailTxtField.text, let firstNameTxt = firstNameTxtField.text, let lastNameTxt = lastNameTxtField.text else {
                return
            }
            //body to be appended to url
            let body = "username=\(usernameTxt)&password=\(passwordTxt)&email=\(emailTxt)&fullname=\(firstNameTxt)%20\(lastNameTxt)"
            request.httpBody = body.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            let id = parseJSON["id"]
                            
                            if id != nil {
                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                DispatchQueue.main.async {
                                    appDelegate.login()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let message = parseJSON["message"] as! String
                                    appDelegate.showInfoView(message: message, color: customOrange)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                let message = error as! String // he just force casts the error as String
                                appDelegate.showInfoView(message: message, color: customOrange)
                            }
                        }
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        let message = error!.localizedDescription
                        appDelegate.showInfoView(message: message, color: customOrange)
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func toLoginScreenBtnTapped(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        present(loginVC!, animated: true, completion: nil)
    }
    

}

