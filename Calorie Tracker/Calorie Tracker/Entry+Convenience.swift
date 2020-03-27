//
//  Entry.swift
//  Calorie Tracker
//
//  Created by Ufuk Türközü on 27.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    var entryRepresentation: EntryRepresentation? {
        
        return EntryRepresentation(calories: self.calories, date: self.date ?? Date())
    }
    
    @discardableResult convenience init(calories: Int16, date: Date, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        
        self.init(calories: entryRepresentation.calories,
                  date: entryRepresentation.date,
                  context: context)
    }
}
