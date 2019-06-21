//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Christopher Aronson on 6/21/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class CalorieTrackerController {
    
    func create(calories: Int16, timestamp: Date, context: NSManagedObjectContext){
        
        _ = CalorieTracker(calories: calories, timestamp: timestamp)
        
        saveToPersistentStore(context: context)
    }
    
    func saveToPersistentStore(context: NSManagedObjectContext) {
        do {
            
            try CoreDataStack.shared.save(context: context)
        } catch {
            
            NSLog("Could not save data. Error in saveToPersistentStore: \(error)")
            
        }
    }
}
