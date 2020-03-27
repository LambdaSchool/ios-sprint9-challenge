//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Ufuk Türközü on 27.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    var entries: [Entry] = []
    
    @discardableResult func create(with calories: Int16, date: Date = Date()) -> Entry {
        
        let entry = Entry(calories: calories, date: date, context: CoreDataStack.shared.mainContext)
        entries.append(entry)

        CoreDataStack.shared.save()
        
        return entry
    }
    
    func update(entry: Entry, with calories: Int16, date: Date) {
        
        entry.calories = calories
        entry.date = date
        
        CoreDataStack.shared.save()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        CoreDataStack.shared.save()
    }
    
}
