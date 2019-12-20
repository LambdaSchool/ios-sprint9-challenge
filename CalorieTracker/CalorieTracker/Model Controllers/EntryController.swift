//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_204 on 12/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class EntryController {
    
    func createEntry(calories: Float, timestamp: Date) {
        Entry(calories: calories, timestamp: timestamp)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Error saving calorie entry \(error)")
        }
    }
    
    func deleteEntry(for entry: Entry) {
    
    }
}
