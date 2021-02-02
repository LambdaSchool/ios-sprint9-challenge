//
//  UserController.swift
//  CalorieTracker
//
//  Created by Sammy Alvarado on 10/12/20.
//

import Foundation
import CoreData

class UserController {
    private let moc = CoreDataStack.shared.mainContext
    
    func saveCalorieToPersistentStore() throws {
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error saving new calorie log: \(error)")
        }
    }
    
    func deleteCalorieFromPersistentStore(_ item: Users) {
        moc.delete(item)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            NSLog("Error deleting saved calorie log: \(error)")
        }
    }

    
}
