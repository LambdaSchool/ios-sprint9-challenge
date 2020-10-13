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
    
    // Didn't end up implementing this functionality elsewhere in the app
    func removeCalories(record: Calories, location: Int) {
        calories.remove(at: location)
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
