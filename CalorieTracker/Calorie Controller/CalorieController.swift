//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Jonalynn Masters on 12/20/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to persistent store: \(error)")
            moc.reset()
        }
    }
    
    func addCaloriesToUser(calories: Double, timeStamp: Date) {
        var dietLevel: String?
        if calories >= 1600 {
            dietLevel = "Better Get A Workout In!"
        } else if calories < 1600 && calories >= 1200 {
            dietLevel = "Sweet Spot"
        } else {
            dietLevel = "Calorie Intake Too Low, Go Eat a Cookie!"
        }
        guard let dietProgress = dietLevel else {return}
        _ = User(calories: calories, timestamp: timeStamp, dietLevel: dietProgress)
        saveToPersistentStore()
    }
    
    func deleteCalorieEntry(calorieEntry: User) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorieEntry)
        saveToPersistentStore()
    }
    
}
