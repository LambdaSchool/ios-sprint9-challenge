//
//  CalorieEntryController.swift
//  Calorie Tracker
//
//  Created by Moin Uddin on 10/26/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] = []
    
    func createCalorieEntry(amount: Int16) {
        let calorie = CalorieEntry(amount: amount)
        calorieEntries.append(calorie)
        saveToPersistent()
    }
    
    func saveToPersistent(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
}
