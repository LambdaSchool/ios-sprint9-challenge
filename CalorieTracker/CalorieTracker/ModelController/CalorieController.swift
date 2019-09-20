//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to persistent store: \(error)")
            moc.reset()
        }
    }
    
    func addCaloriesToUser(calories: String, timeStamp: Date) -> User {
        let addedCaloriesToUser = User(calories: calories, timestamp: timeStamp)
        saveToPersistentStore()
        return addedCaloriesToUser
    }
    
}
