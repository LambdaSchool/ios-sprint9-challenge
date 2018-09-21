//
//  AppDelegate.swift
//  ios-sprint-9-challenge
//
//  Created by David Doswell on 9/21/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = CalorieTableViewController()
        let navVC = UINavigationController(rootViewController: vc)

        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

