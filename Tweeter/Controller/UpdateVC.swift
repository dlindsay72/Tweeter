//
//  UpdateVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-24.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class UpdateVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var updateBtn: CustomRoundedButton!
    @IBOutlet weak var fullnameLbl: UILabel!
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self

        let username = user!["username"] as? String
        let fullname = user!["fullname"] as? String
        let fullnameArray = fullname!.split { $0 == " " }.map(String.init)
        let firstName = fullnameArray[0]
        let lastName = fullnameArray[1]
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        navigationItem.title = "PROFILE"
        
        usernameTextField.text = username
        firstnameTextField.text = firstName
        lastnameTextField.text = lastName
        emailTextField.text = email
        fullnameLbl.text = "\(firstnameTextField.text!) \(lastnameTextField.text!)"
        
        firstnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if ava != "" {
            // url path to image
            let imageURL = URL(string: ava!)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.profileImage.image = UIImage(data: imageData!)
                    })
                }
            })
        }
        
        updateBtn.isEnabled = false
        updateBtn.alpha = 0.4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction func updateBtnWasPressed(_ sender: Any) {
        if usernameTextField.text!.isEmpty || firstnameTextField.text!.isEmpty || lastnameTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            firstnameTextField.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            lastnameTextField.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            emailTextField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
        } else {
            let username = usernameTextField.text!.lowercased()
            let fullname = fullnameLbl.text!
            let email = emailTextField.text!.lowercased()
            let id = user!["id"]!
            
            let url = URL(string: HostKey.updateUser.rawValue)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let body = "username=\(username)&fullname=\(fullname)&email=\(email)&id=\(id)"
            request.httpBody = body.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("error while parsing")
                                return
                            }
                            let id = parseJSON["id"]
                            
                            if id != nil {
                                // save user info we received from our host
                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                DispatchQueue.main.async(execute: {
                                    appDelegate.login()
                                })
                            }
                        } catch {
                            print("There was an error")
                        }
                    })
                } else {
                    print("There was an error in URLSession data task: \(error.debugDescription)")
                }
            }.resume()
        }
    }
    

}

extension UpdateVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textfield: UITextView) {
        fullnameLbl.text = "\(firstnameTextField.text!) \(lastnameTextField.text!)"
        
        if usernameTextField.text!.isEmpty || firstnameTextField.text!.isEmpty || lastnameTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            updateBtn.isEnabled = false
            updateBtn.alpha = 0.4
        } else {
            updateBtn.isEnabled = true
            updateBtn.alpha = 1.0
        }
    }
}





