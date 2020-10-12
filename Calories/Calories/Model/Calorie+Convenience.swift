//
//  Calorie+Convenience.swift
//  Calories
//
//  Created by Norlan Tibanear on 10/10/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import Foundation
import CoreData


extension Calorie {
   
    var calorieRepresentation: CalorieRepresentation? {
        guard let timestamp = timestamp else { return nil }
        return CalorieRepresentation(calories: Int(calories), timestamp: timestamp)
    }
    
    @discardableResult convenience init(calories: Int,
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
    
    
}//

