//
//  Notifications.swift
//  CalorieTracker
//
//  Created by Keri Levesque on 3/27/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
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
