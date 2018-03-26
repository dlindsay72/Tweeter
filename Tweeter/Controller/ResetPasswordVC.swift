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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetBtnWasPressed(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
        } else {
            let email = emailTextField.text!.lowercased()
            //send mysql/php/hosting request
            let url = URL(string: "http://localhost:8080/TweeterBackend/resetPassword.php")!
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
                            
                            print(parseJSON)
                        } catch {
                            print("Caught an error while parsing: \(error.localizedDescription)")
                        }
                    })
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }).resume()
            
        }
    }
    
    @IBAction func goBackBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
