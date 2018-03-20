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
            //send mysql/php/hosting request
        }
    }
    
    @IBAction func goBackBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
