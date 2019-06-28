//
//  Meal+Convenience.swift
//  CalorieTracker
//
//  Created by Jonathan Ferrer on 6/28/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

extension Meal {

    convenience init(calories: Int, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
}
