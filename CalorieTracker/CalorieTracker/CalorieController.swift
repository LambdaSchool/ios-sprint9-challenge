//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Vuk Radosavljevic on 9/21/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation

class CalorieController {
    
    
    
    var caloriesArray = [Calorie]() {
        didSet {
            print(caloriesArray)
        }
    }
    
    func create(calories: Int16) {
        let calorie = Calorie(calories: calories)
        caloriesArray.append(calorie)
        saveToPersistentStore()
    }
    
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
}
