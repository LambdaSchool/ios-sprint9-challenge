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
    
    @discardableResult convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        // Calling the designated initializer
        self.init(context: context)
        
        self.calories = calories
        self.date = date
    }
}
