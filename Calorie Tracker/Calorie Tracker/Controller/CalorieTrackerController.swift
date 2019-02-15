//
//  CalorieTrackerController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//



import Foundation
import CoreData

class CalorieTrackerController {
    var entries: [CalorieEntry] {
        
        get {
            let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
            let result = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
            return result
        } set {
            
        }
    }
    
    func add(calorie: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let newEntry = CalorieEntry(calorie: calorie)
        entries.append(newEntry)
    }
}
