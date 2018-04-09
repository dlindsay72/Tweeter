//
//  HomeVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-03-29.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = (user!["username"] as AnyObject).uppercased
        let fullname = user!["fullname"] as? String
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        usernameLbl.text = username
        
        fullNameLbl.text = fullname
        
        emailLbl.text = email
        editProfileBtn.layer.cornerRadius = 5.0
        
        // get user profile pic
        
        if ava != "" {
            
        }
        

    }
    
    @IBAction func editProfileBtnWasPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    

}

extension HomeVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}















