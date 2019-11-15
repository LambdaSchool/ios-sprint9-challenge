//
//  EntryController.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

class EntryController {
    
    func create(entryWithCalories calories: Int16, user: User, context: NSManagedObjectContext) {
        Entry(calories: calories, user: user, context: context)
        CoreDataStack.shared.save(context: context)
    }
    
    func delete(entry: Entry, context: NSManagedObjectContext) {
        context.delete(entry)
        CoreDataStack.shared.save(context: context)
    }
    
}
