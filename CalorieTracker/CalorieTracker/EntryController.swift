//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Jerry haaser on 11/15/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

class EntryController {
    func createEntry(with calories: Double) {
        let entry = Entry(calories: calories)
        CoreDataStack.shared.save()
    }
    func delete(entry: Entry) {
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            context.delete(entry)
            CoreDataStack.shared.save()
        }
    }
    func update(entry: Entry, calories: Double) {
    }
}
