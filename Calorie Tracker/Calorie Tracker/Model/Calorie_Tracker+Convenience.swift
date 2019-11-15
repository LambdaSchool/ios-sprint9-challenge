//
//  Calorie_Tracker+Convenience.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

extension Entry {
    @discardableResult convenience init(calories: Int16, date: Date = Date(), context: NSManagedObjectContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
}
