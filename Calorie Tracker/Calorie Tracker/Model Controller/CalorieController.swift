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
    func createCalorie(with calories: Double) {
        _ = Calorie(calories: calories)
        saveToPersistentStore()
        
        NotificationCenter.default.post(name: .didAddCalorie, object: nil)
    }
    
    func update(calorie: Calorie, with calories: Double) {
        calorie.calories = calories
        
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
