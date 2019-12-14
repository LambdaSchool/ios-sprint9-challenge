//
//  CalorieController.swift
//  CalorieCounter
//
//  Created by Joel Groomer on 12/14/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func create(amount: Int, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = Calorie(amount: amount, timestamp: timestamp, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .calorieListUpdated, object: nil)
            } catch {
                print("Unable to save new Calorie: \(error)")
                context.reset()
            }
        }
    }
    
    func delete(calorie: Calorie, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(calorie)
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after deleting: \(error)")
                context.reset()
            }
        }
    }
}
