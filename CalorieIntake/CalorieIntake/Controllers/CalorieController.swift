//
//  CalorieController.swift
//  CalorieIntake
//
//  Created by Benjamin Hakes on 2/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

class CalorieController {
    
    init(){}
    
    func deleteCalorieEntry(for calorieEntry: CalorieEvent){
        CoreDataStack.shared.mainContext.delete(calorieEntry)
        self.saveToPersistentStore()
    }
    
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }

}
