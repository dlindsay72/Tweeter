//
//  TabBarVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-03.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBar.barTintColor = #colorLiteral(red: 0.3058823529, green: 0.7098039216, blue: 0.8156862745, alpha: 1)
        self.tabBar.isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 244.0/255.0, green: 198.0/255.0, blue: 97.0/255.0, alpha: 1.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.changeImageColor(to: #colorLiteral(red: 0.8134617299, green: 0.6595862562, blue: 0.3273066738, alpha: 1)).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    


}

extension UIImage {
    func changeImageColor(to color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
