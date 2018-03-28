//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-02-27.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundImage = UIImageView()
    
    // boolean to check is infoView is currently showing or not
    @objc var infoViewIsShowing = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.window!.bounds.height * 1.688, height: self.window!.bounds.height)
        backgroundImage.image = UIImage(named: "skyBackground.jpg")
        
        self.window!.addSubview(backgroundImage)
        moveBackgroundLeft()
        return true
    }
    
    func moveBackgroundLeft() {
        UIView.animate(withDuration: 45, animations: {
            self.backgroundImage.frame.origin.x = -self.backgroundImage.bounds.width + self.window!.bounds.width
        }) { (finished) in
            if finished {
                //move right
                self.moveBackgroundRight()
            }
        }
    }
    
    func moveBackgroundRight() {
        UIView.animate(withDuration: 45, animations: {
            self.backgroundImage.frame.origin.x = 0
        }) { (finished) in
            if finished {
                //move left
                self.moveBackgroundLeft()
            }
        }
    }
    
    // info view on top
    func showInfoView(message: String) {
        if !infoViewIsShowing {
            infoViewIsShowing = true
            
            let infoViewHeight = self.window!.bounds.height / 14.2
            let infoViewY = 0 - infoViewHeight
            let infoView = UIView(frame: CGRect(x: 0, y: infoViewY, width: self.window!.bounds.width, height: infoViewHeight))
            
            infoView.backgroundColor = colorSmoothRed
            self.window!.addSubview(infoView)
            
            let infoLabelWidth = infoView.bounds.width
            let infoLabelHeight = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            let infoLabel = UILabel()
        
            infoLabel.frame.size.width = infoLabelWidth
            infoLabel.frame.size.height = infoViewHeight
            infoLabel.numberOfLines = 0
            infoLabel.text = message
            infoLabel.font = UIFont(name: "Courier New Regular", size: 12)
            infoLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

