//
//  CalorieTrackerController.swift
//  calorie tracker
//
//  Created by Thomas Sabino-Benowitz on 5/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class CalorieTrackerController {
//    Save entry to CoreData method
    func saveEntryToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func addEntry(calories: Double) {
        _ = Entry(calories: calories)
        saveEntryToPersistentStore()
    }
}
