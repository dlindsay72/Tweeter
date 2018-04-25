//
//  UpdateVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-24.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class UpdateVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var updateBtn: CustomRoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func updateBtnWasPressed(_ sender: Any) {
        //update user profile
        
        //dismiss controller
        dismiss(animated: true, completion: nil)
    }
    

}
