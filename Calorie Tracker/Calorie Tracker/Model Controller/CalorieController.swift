//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Jordan Christensen on 10/19/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func createCalorie(with calories: Int) {
        let cals = Int16(calories)
        let calorie = Calorie(calories: cals)
        saveToPersistentStore()
    }
    
    func update(calorie: Calorie, with calories: Int) {
        calorie.calories = Int16(calories)
        
        saveToPersistentStore()
    }
    
    func delete(calorie: Calorie) {
        CoreDataStack.shared.mainContext.delete(calorie)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
