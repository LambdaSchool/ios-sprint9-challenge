//
//  Notifications.swift
//  SprintChallengeCalorieTracker
//
//  Created by morse on 12/20/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let calorieIntakeAdded = Notification.Name("calorieIntakeAdded")
}

extension NotificationCenter {
    func postOnMainThread(name: NSNotification.Name, object: Any?) {
        DispatchQueue.main.async {
            NotificationCenter.self.default.post(name: name, object: nil)
        }
    }
}
