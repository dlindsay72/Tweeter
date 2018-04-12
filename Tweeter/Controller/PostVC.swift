//
//  PostVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-11.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class PostVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var charactersLbl: UILabel!
    @IBOutlet weak var selectPicBtn: CustomRoundedButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postBtn: CustomRoundedButton!
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.layer.cornerRadius = 5.0
        postTextView.contentInsetAdjustmentBehavior = .never
        
        configurePostButton(alpha: 0.5, isEnabled: false)
    }
    
    //MARK: - Custom Methods
    func configurePostButton(alpha: CGFloat, isEnabled: Bool) {
        postBtn.isEnabled = isEnabled
        postBtn.alpha = alpha
    }
    
    //MARK: - IBActions
    @IBAction func postBtnWasPressed(_ sender: Any) {
        if !postTextView.text.isEmpty && postTextView.text.count <= 140 {
            //post
        }
    }
    
    @IBAction func selectPicBtnWasPressed(_ sender: Any) {
        
    }
    
}

extension PostVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text.count
        let spacing = CharacterSet.whitespacesAndNewlines
        charactersLbl.text = String(140 - chars)
        
        if chars > 140 {
            charactersLbl.textColor = colorSmoothRed
            configurePostButton(alpha: 0.5, isEnabled: false)
        } else if postTextView.text.trimmingCharacters(in: spacing).isEmpty {
            configurePostButton(alpha: 0.5, isEnabled: false)
        } else {
            charactersLbl.textColor = customBlue
            configurePostButton(alpha: 1.0, isEnabled: true)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}
