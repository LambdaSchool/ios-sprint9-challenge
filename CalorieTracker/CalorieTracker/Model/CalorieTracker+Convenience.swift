//
//  CalorieTracker+Convenience.swift
//  CalorieTracker
//
//  Created by Craig Swanson on 2/23/20.
//  Copyright © 2020 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTracker {
    
    convenience init(calories: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
}
