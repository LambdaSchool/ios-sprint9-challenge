//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    // MARK: - Properties
    
    private(set) var calorieEntries: [Calories] = []
    
    // MARK: - CRUD Methods
    
    func createEnry(withCalorieCount count: Int) {
        let entry = Calories(count: count)
        calorieEntries.append(entry)
        saveToPersistentStore()
    }
    
    // MARK: - Private Methods
    
    private func saveToPersistentStore() {
        do{
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
