//
//  NotificationExtensions.swift
//  CalorieTracker
//
//  Created by Joshua Rutkowski on 5/3/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation


extension Notification.Name {
    static let calorieIntakeAdded = Notification.Name(PropertyKeys.calorieIntakeAdded)
}

extension NotificationCenter {
    func postOnMainThread(name: NSNotification.Name, object: Any?) {
        DispatchQueue.main.async {
            NotificationCenter.self.default.post(name: name, object: nil)
        }
    }
}
