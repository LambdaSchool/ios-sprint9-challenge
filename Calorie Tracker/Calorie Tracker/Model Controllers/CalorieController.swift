//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Bronson Mullens on 8/14/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    // MARK: - Methods
    
    func create(calories: Int,
                dateAdded: Date = Date(),
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = Calories(calories: calories, dateAdded: dateAdded, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .calorieListUpdated, object: nil)
            } catch {
                NSLog("Error saving new Calories: \(error)")
                context.reset()
            }
        }
    }
    
    func delete(calories: Calories,
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(calories)
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .calorieListUpdated, object: nil)
            } catch {
                NSLog("Error not saving after deleting: \(error)")
                context.reset()
            }
        }
    }
    
}
