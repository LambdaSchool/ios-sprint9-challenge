//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Bradley Diroff on 5/22/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    @discardableResult convenience init(calories: Int, timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: CoreDataStack.shared.mainContext)
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
}
