//
//  NavVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-03-29.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: customSoftOrange]
        self.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationBar.barTintColor = customBlue
        self.navigationBar.isTranslucent = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


}
