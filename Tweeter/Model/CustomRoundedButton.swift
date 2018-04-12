//
//  CustomRoundedButton.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-11.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class CustomRoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 5.0
    }
}
