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
        
    }
    
    @IBAction func notAMemberBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
