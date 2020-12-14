//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Craig Belinfante on 10/11/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    func addCalories(identifier: UUID = UUID(), calories: Int, time: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let totalCalories = CalorieTracker(identifier: identifier, calories: calories, time: time, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("\(error)")
            }
        }
    }
    
    func removeCalories(calories: CalorieTracker, context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: @escaping (Error?) -> Void = { _ in }) {
        
        context.perform {
            do {
                context.delete(calories)
                try CoreDataStack.shared.save(context: context)
                completion(nil)
            } catch {
                NSLog("\(error)")
                completion(error)
            }
        }
    }
}
