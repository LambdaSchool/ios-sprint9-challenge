//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by John McCants on 2/19/21.
//  Copyright © 2021 John McCants. All rights reserved.
//

import Foundation
import CoreData


extension Calorie {
    var calorieRepresentation: CalorieRepresentation? {

        return CalorieRepresentation(calories: Int(calories), timeStamp: timestamp ?? Date())
    }
    
    @discardableResult convenience init(calories: Int, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
}
