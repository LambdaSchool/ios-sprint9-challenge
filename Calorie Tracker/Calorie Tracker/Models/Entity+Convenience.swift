//
//  Entry+Convenience.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

extension Entity {

    @discardableResult convenience init(calories: Int,
                     timestamp: Date,
                     context: NSManagedObjectContext) {
        self.init(context: context)

        self.calories = Int64(truncatingIfNeeded: calories)
        self.timestamp = timestamp
    }
}
