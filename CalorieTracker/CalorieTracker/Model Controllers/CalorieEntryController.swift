//
//  CalorieEntryController.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] = []
    
    init() {
        fetchEntries()
    }
    
    func createCalorieEntry(calories: Double) {
        let entry = CalorieEntry(calories: calories)
        do {
            try CoreDataStack.sahred.mainContext.save()
            calorieEntries.append(entry)
            NotificationCenter.default.post(name: .didRecieveNewCalorieEntries, object: self)
        } catch {
            NSLog("Error Saving Managed Object Context")
        }
    }
    
    func fetchEntries() {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        do {
            let entries = try CoreDataStack.sahred.mainContext.fetch(fetchRequest)
            calorieEntries = entries
            NotificationCenter.default.post(name: .didRecieveNewCalorieEntries, object: self)
        } catch {
            NSLog("Error fetching Calorie Entries")
        }
        
    }
    
    
    
}
