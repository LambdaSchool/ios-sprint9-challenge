//
//  Calorie+Convenience.swift
//  SprintCallengeWk11
//
//  Created by Bradley Diroff on 4/24/20.
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
