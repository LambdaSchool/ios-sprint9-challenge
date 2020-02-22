//
//  User+Convenience.swift
//  CalorieTracker
//
//  Created by Jonalynn Masters on 12/20/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(calories: Double, timestamp: Date, dietLevel: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        self.dietLevel = dietLevel
    }
}

