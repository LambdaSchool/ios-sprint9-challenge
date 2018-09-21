//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Jonathan T. Miles on 9/21/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    // MARK: - Create (Core Data Version)
    
    func createCalorieCount(with calories: Double) {
        let _ = CalorieCount(calories: calories)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence Methods
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [CalorieCount] {
        let fetchRequest: NSFetchRequest<CalorieCount> = CalorieCount.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching CalorieCounts: \(error)")
            return []
        }
    }
    
    // MARK: - Properties
    
    var calorieCounts: [CalorieCount] {
        return loadFromPersistentStore()
    }
    
}
