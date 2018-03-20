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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
        } else {
            
            let username = usernameTextField.text!.lowercased()
            let password = passwordTextField.text!
            //send request to MYSQL database
            let url = URL(string: "http://localhost:8080/TweeterBackend/login.php")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            let body = "username=\(username)&password=\(password)"
            request.httpBody = body.data(using:.utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("error while parsing")
                            return
                        }
                        print(parseJSON)
                        
                        let id = parseJSON["id"] as? String
                        
                        if id != nil {
                            // successfully logged in
                        }
                        
                    } catch {
                        print("Caught an error: \(error.localizedDescription)")
                    }
                } else {
                    print("Error: \(error.debugDescription)")
                }
            }).resume()
            
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
