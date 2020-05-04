//
//  EntryController.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation

class EntryController {
    func saveToPersistentStore() {
        let context  = CoreDataStack.shared.container.viewContext
        do {
            try context.save()
        } catch {
            NSLog("Error saving managed context: \(error)")
        }
    }
    // Saves context to Core Data
    func save() {
        let context = CoreDataStack.shared.mainContext
        do {
            try context.save()
        } catch {
            print("There was a problem saving: \(error)")
        }
    }
    func delete(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        context.delete(entry)
    }
}
