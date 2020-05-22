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
        do {
            try CoreDataStack.shared.mainContext.save()
            
            NotificationCenter.default.post(name: .whenUpdateGraph, object: self)
        } catch {
            NSLog("Error managing the posts: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Calories] {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        
        do {
           return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            
        } catch {
            NSLog("Error fetching :\(error)")
        }
        return []
    }
    
    func createCalories(calories: Int, timestamp: Date = Date()) -> Calories {
        let calories = Calories(calories: calories, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        
        saveToPersistentStore()
        return calories
        
    }
    
    func deleteCalories(calories: Calories) {
        
       CoreDataStack.shared.mainContext.delete(calories)
        saveToPersistentStore()
       
    }
    
    
}
