//
//  UINavigationController+StatusBar.swift
//  Calorie-Tracker
//
//  Created by Marlon Raskin on 9/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

extension UINavigationController {
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle ?? .default
	}
}
