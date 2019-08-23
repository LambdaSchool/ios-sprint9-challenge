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
        guard let amountDouble = Double(amount) else { return }
        let _ = CaloriesEntry(amount: amountDouble)
        
        saveToPersistentStore()
        NotificationCenter.default.post(name: .calorieEntryAdded, object: nil)
    }
    
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        moc.perform {
            do {
                try moc.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
}

extension NSNotification.Name {
    static let calorieEntryAdded = NSNotification.Name("calorieEntryAdded")
}
