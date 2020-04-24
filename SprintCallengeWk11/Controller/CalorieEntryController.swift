//
//  CalorieEntryController.swift
//  SprintCallengeWk11
//
//  Created by Bradley Diroff on 4/24/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    func create(_ calories: Int) {
        CalorieEntry(calories: calories, timestamp: Date(), context: CoreDataStack.shared.mainContext)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
