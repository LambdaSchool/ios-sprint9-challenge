//
//  CaloriesController.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

class CaloriesController {
    
    var calories: [Calories] {
        
        loadFromPersistentStore()
    }
    
    
    
    func saveToPersistentStore() {
        
    }
    func loadFromPersistentStore() -> Calories {
        
    }
    
    func createCalories(calories: Int, timestamp: Date = Date()) -> Calories {
        let calories = Calories(calories: calories, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
        return calories
        
    }
    
    
}
