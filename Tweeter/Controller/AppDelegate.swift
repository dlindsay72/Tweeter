//
//  AppDelegate.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-02-27.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
var user: NSDictionary?

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
        
        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
    
        if user != nil {
            if let user = user {
                let id = user["id"] as? String
                
                if id != nil {
                    login()
                }
            }
        }
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
    func showInfoView(message: String, color: UIColor) {
        if !infoViewIsShowing {
            infoViewIsShowing = true
            
            let infoViewHeight = self.window!.bounds.height / 14.2 + 50
            let infoViewY = 0 - infoViewHeight
            let infoView = UIView(frame: CGRect(x: 0, y: infoViewY, width: self.window!.bounds.width, height: infoViewHeight))
            
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            let infoLabelWidth = infoView.bounds.width
            let infoLabelHeight = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            let infoLabel = UILabel()
        
            infoLabel.frame.size.width = infoLabelWidth
            infoLabel.frame.size.height = infoLabelHeight
            infoLabel.numberOfLines = 0
            infoLabel.text = message.uppercased()
            infoLabel.font = UIFont.init(name: "Courier-Bold", size: 30)
            infoLabel.minimumScaleFactor = 0.4
            infoLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            //animate infoView
            UIView.animate(withDuration: 0.2, animations: {
                //move infoView down
                infoView.frame.origin.y = 0
                
                // if animation did finish
            }, completion: { (finished) in
                //if it is true
                if finished {
                    
                    UIView.animate(withDuration: 0.1, delay: 2, options: .curveLinear, animations: {
                        // move infoView up
                        infoView.frame.origin.y = infoViewY
                        
                        // if finished all animations
                    }, completion: { (finished) in
                        if finished {
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                    })
                }
            })
        }
    }
    
    // function to pass to HomeVC or to tab bar
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        window?.rootViewController = tabBar
        
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

