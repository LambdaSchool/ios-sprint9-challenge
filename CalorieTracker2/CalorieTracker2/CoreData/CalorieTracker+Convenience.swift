//
//  CalorieTracker+Convenience.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTracker {
    @discardableResult convenience init(calories: Double,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
}
