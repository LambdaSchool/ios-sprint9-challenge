//
//  CalorieEntryController.swift
//  iOSSprintCalorieTracker
//
//  Created by Patrick Millet on 1/31/20.
//  Copyright © 2020 Patrick Millet. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController: NSObject {
    
    // MARK: - Properties
    
    var persistentStoreController: PersistentStoreController = CoreDataStack()
    
    var entryCount: Int {
        persistentStoreController.itemCount
    }
    
    var entries: [CalorieEntry]? {
        persistentStoreController.allItems as? [CalorieEntry]
    }
    
    var delegate: PersistentStoreControllerDelegate? {
        get {
            return persistentStoreController.delegate
        }
        set(newDelegate) {
            persistentStoreController.delegate = newDelegate
        }
    }
    
    // MARK: - Methods
    
    func createEntry(withCalories calories: Int) throws {
        let context = persistentStoreController.mainContext
        guard let entry = CalorieEntry(calories: calories, context: context)
            else { throw NSError() }
        try persistentStoreController.create(item: entry, in: context)
    }
    
    func getEntry(at indexPath: IndexPath) -> CalorieEntry? {
        return persistentStoreController.fetchItem(at: indexPath) as? CalorieEntry
    }
    
    func deleteEntry(at indexPath: IndexPath) throws {
        guard let thisEntry = getEntry(at: indexPath) else { throw NSError() }
        try persistentStoreController.delete(thisEntry, in: nil)
    }
}
