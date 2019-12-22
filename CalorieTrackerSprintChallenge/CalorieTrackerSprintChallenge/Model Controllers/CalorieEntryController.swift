//
//  CalorieEntryController.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation

class CalorieEntryController {
    var entriesArray: [CalorieEntryRep] = []
    
    @discardableResult func createEntry(amount: String, timestamp: Date) -> CalorieEntry {
        let entry = CalorieEntry(amount: amount, timestamp: timestamp, context: CoreDataStack.shared.mainContext)
        let entryRep = CalorieEntryRep(amount: amount, timestamp: timestamp)
        entriesArray.append(entryRep)
        CoreDataStack.shared.saveToPersistentStore()
        return entry
    }
    
    func delete(calorieEntry: CalorieEntry) {
        CoreDataStack.shared.mainContext.delete(calorieEntry)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
