//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Nathanael Youngren on 3/15/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    var entries: [Entry] {
        return loadFromCoreDataStore()
    }
    
    func createEntry(numberOfCalories: Int) {
        _ = Entry(calories: numberOfCalories)
        saveToCoreDataStore()
    }
    
    func loadFromCoreDataStore() -> [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching from core data.")
            return []
        }
    }
    
    func saveToCoreDataStore(moc: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        moc.perform {
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving to core data.")
            }
        }
    }
}
