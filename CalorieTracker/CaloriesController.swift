//
//  CaloriesController.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import Foundation
import CoreData

class CaloriesController {
    var calories: [Calories] = []
    
    let moc = CoreDataStack.shared.mainContext
    
    func addCalories(howMany: Double) {
        let intake = Calories(intake: howMany)
        calories.append(intake)
        
        do {
            try saveToPersistentStore()
        } catch {
            NSLog("Error adding calories: \(error)")
        }
    }
    
    func removeCalories(record: Calories) {
        moc.delete(record)
        
        do {
            try saveToPersistentStore()
        } catch {
            NSLog("Error removing calories: \(error)")
        }
    }
    
    private func saveToPersistentStore() throws {
        try moc.save()
    }
}
