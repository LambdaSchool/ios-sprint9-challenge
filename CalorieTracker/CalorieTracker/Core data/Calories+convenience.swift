//
//  Calories+convenience.swift
//  CalorieTracker
//
//  Created by Kevin Stewart on 6/12/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    @discardableResult
    convenience init (calories: Int,
                      timestamp: Date = Date(),
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
}
