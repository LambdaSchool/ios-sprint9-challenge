//
//  Notification+Names.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var dataUpdated = Notification.Name("dataUpdated")
    static var setUser = Notification.Name("setUser")
    static var showAllUsers = Notification.Name("showAllUsers")
}
