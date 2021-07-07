//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_34 on 3/15/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import CoreData

class CalorieController {
    
    //MARK: - Properties
    let moc = CoreDataStack.shared.mainContext
    
    //create
    func create(calories: Double) {
        _ = CalorieIntake(calories: calories)
        saveToPersistentStore()
    }
    
    //delete
    func delete(calorieIntake: CalorieIntake) {
        moc.delete(calorieIntake)
        saveToPersistentStore()
    }
    
    //save
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
