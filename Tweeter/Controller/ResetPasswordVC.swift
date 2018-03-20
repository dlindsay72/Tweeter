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
        
    }
    
    @IBAction func goBackBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
