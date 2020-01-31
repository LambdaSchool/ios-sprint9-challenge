//
//  CalorieEntry+Convenience.swift
//  iOSSprintCalorieTracker
//
//  Created by Patrick Millet on 1/31/20.
//  Copyright © 2020 Patrick Millet. All rights reserved.
//

import Foundation
import CoreData


extension Calorie {

    // MARK: - Properties
    
    var calorieEntry: Calorie? {
        
        guard let identifier = identifier,
        let timestamp = timestamp else { return nil }
        return Calorie(calories: calories, identifier: identifier, timestamp: timestamp)
    }

    // MARK: - Convenience inits
    
    convenience init(calories: Double,
                     identifier: UUID = UUID(),
                     timestamp: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.calories = calories
        self.identifier = identifier
        self.timestamp = timestamp
    }
}

