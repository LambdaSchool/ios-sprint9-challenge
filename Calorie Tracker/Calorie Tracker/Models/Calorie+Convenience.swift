//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData


extension Calories {
    convenience init(count: Int,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.count = Int16(count)
        self.date = date
    }
    
    convenience init?(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let date = calorieRepresentation.date
        let count = calorieRepresentation.calories
        
        self.init(count: count, date: date)
    }
}
