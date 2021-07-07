//
//  AppDelegate.swift
//  CalorieTracker
//
//  Created by Bradley Yin on 9/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            fatalError("termination save failed")
        }
    }
}
