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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registerBtnTapped(_ sender: Any) {
        if usernameTxtField.text!.isEmpty || passwordTxtField.text!.isEmpty || emailTxtField.text!.isEmpty || firstNameTxtField.text!.isEmpty || lastNameTxtField.text!.isEmpty {
            usernameTxtField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)])
            emailTxtField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            passwordTxtField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            firstNameTxtField.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
            lastNameTxtField.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)])
        } else {
            // create new user in MySql
        }
    }
    
    @IBAction func toLoginScreenBtnTapped(_ sender: Any) {
        print("Login screen")
    }
    

}

