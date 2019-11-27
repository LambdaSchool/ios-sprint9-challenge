//
//  Intake+Convenience.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Intake {
    
    // This initializer sets up the Core Data (NSManagedObject) part of the Intake, then gives it the properties unique to an Intake entity.
    
    @discardableResult convenience init(calories: Int16, date: Date = Date(), context: NSManagedObjectContext) {
        
        // Calling the designated initializer
        self.init(context: context)
        
        self.calories = calories
        self.date = date
    }
}
