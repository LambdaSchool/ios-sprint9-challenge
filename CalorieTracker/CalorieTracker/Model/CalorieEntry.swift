//
//  CalorieEntry.swift
//  CalorieTracker
//
//  Created by Josh Kocsis on 8/15/20.
//

import Foundation
import CoreData

class CalorieEntry {

    let coreDataStack = CoreDataStack.shared.mainContext

    func create(calories: Int16) {
        Tracker(calories: calories)
        save()
    }

    func save() {
        do {
            try coreDataStack.save()
        } catch {
            NSLog("Error saving: \(error)")
            coreDataStack.reset()
        }
    }
}
