//
//  Calories+Convenience.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    @discardableResult convenience init(calories: Int, timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.calories = Int64(truncatingIfNeeded: calories)
        self.timestamp = timestamp
    }
}
