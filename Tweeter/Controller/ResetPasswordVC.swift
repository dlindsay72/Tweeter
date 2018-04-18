//
//  ResetPasswordVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-03-20.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @IBAction func resetBtnWasPressed(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
        } else {
            let email = emailTextField.text!.lowercased()
            //send mysql/php/hosting request
            let url = URL(string: HostKey.resetPassword.rawValue)!
            //request to send to this file
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let body = "email=\(email)"
            request.httpBody = body.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            guard let parseJSON = json else {
                                print("Error while parsing during reset password")
                                return
                            }
                            
                            let email = parseJSON["email"]
                            
                            //successfully reset
                            if email != nil {
                                // done
                                DispatchQueue.main.async {
                                    let message = parseJSON["message"] as! String
                                    appDelegate.showInfoView(message: message, color: customGreen)
                                }
                            } else {
                                print(error.debugDescription)
                                DispatchQueue.main.async {
                                    let message = parseJSON["message"] as! String
                                    appDelegate.showInfoView(message: message, color: customOrange)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                let message =  error as! String// he just force casts the error as String
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
    
    @IBAction func goBackBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
