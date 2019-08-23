//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Sean Acres on 8/23/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func createCaloriesEntry(amount: String) {
        let _ = CaloriesEntry(amount: amount)
        
        saveToPersistentStore()
    }
    
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.container.newBackgroundContext()
        
        moc.perform {
            do {
                try moc.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
}
