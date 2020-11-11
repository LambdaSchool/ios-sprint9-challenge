//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Nick Nguyen on 11/11/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
