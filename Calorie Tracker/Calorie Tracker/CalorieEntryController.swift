//
//  CalorieEntryController.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    var entries: [CalorieEntry] = [] {
        didSet {
            saveToPersistentStore()
        }
    }
    func createEntry(calories: Double, timestamp: Date) {
        let newEntry = CalorieEntry(calories: calories, timestamp: timestamp)
        entries.append(newEntry)
        saveToPersistentStore()
    }
    func deleteAllEntries() {
        let moc = CoreDataStack.shared.mainContext
        for entry in entries {
            moc.delete(entry)
            saveToPersistentStore()
        }
    }
//    func deleteEntry(entry: CalorieEntry) {
//
//    }
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("Error saving data to persistent store: \(error)")
        }
    }
    func fetchCalorieEntries(completion: (Error?) -> Void) {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let entries = try moc.fetch(fetchRequest)
            self.entries = entries
            completion(nil)
        } catch {
            print("Error fetching entries from persistent store: \(error)")
            completion(error)
        }
    }
}
