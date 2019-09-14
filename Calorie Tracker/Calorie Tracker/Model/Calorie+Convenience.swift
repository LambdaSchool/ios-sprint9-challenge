//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Michael Stoffer on 9/14/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    var calorieRepresentation: CalorieRepresentation? {
        guard let calories = self.calories,
            let created = self.created else { return nil }

        return CalorieRepresentation(calories: calories, created: created)
    }
    
    // Initializes a Calorie Object
    convenience init(calories: String, created: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.created = created
    }
    
    // Initializes a Calorie Object from a CalorieRepresentation
    convenience init?(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(calories: calorieRepresentation.calories, created: calorieRepresentation.created, context: context)
    }
}
