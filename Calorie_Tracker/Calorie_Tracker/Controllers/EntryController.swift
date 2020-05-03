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
        let moc = CoreDataStack.shared.container.viewContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed context: \(error)")
        }
    }
    
    // Saves content to Core Data
    func save() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("There was a problem saving: \(error)")
        }
    }
    
    func update(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            print("there was a problem Updating Core Data: \(error)")
        }
        
    }
    
    func delete(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
    }
}
