//
//  EntryController.swift
//  CalorieSprint
//
//  Created by Ryan Murphy on 6/28/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching \(error)")
            return []
        }
    }
    
    func saveToCoreDataStore(moc: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        moc.perform {
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving \(error)")
            }
        }
    }
}
