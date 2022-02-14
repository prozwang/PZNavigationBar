//
//  AppDelegate.swift
//  Navigator
//
//  Created by CIB on 2021/9/29.
//

import UIKit
import PZNavigation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        
        let navVC: UINavigationController = BaseNavigationController(rootViewController: ViewController())
        navVC.setNavigationBarHidden(false, animated: true)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
 
        return true
    }

}

