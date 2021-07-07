//
//  CaloriesController.swift
//  CaloriesApp
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

class CaloriesController {

private(set) var calories: [Calories] = []

    
func addCalories(calorieAmount: Double) {
   
    _ = Calories(calorieAmount: calorieAmount)
   
    saveToPersistentStorage()
    
}


func saveToPersistentStorage(){
    //Save changes to disk
    let moc = CoreDataStack.shared.mainContext
    do {
        try moc.save()//Save the task to the persistent store
    } catch {
        print("Error saving MOC (managed object context): \(error)")
    }
}

func deleteCalories(calorie: Calories) {
    let moc = CoreDataStack.shared.mainContext
    
    moc.delete(calorie)
    
    saveToPersistentStorage()
}
}
