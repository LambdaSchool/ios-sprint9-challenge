//
//  Calorie_Tracker+Convenience.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

extension Entry {
    @discardableResult convenience init(calories: Int16, user: User, context: NSManagedObjectContext, date: Date = Date()) {
        self.init(context: context)
        self.calories = calories
        self.user = user
        self.date = date
    }
}

extension User {
    @discardableResult convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
}
