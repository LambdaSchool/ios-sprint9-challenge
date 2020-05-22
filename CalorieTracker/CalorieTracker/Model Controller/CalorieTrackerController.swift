//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Mark Poggi on 5/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation

class CalorieTrackerController {

    func saveEntryToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object contect: \(error)")
        }
    }

    func addEntry(numberOfCalories: Double) {
        _ = CalorieLog(numberOfCalories: numberOfCalories)
        saveEntryToPersistentStore()
    }
}
