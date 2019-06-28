//
//  CaloriesController.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

class CaloriesController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            fatalError("Error saving to core data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [Calories] {
        var calories: [Calories] {
            do {
                let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
                let result = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                return result
            } catch {
                fatalError("Error fetching Data: \(error)")
            }
        }
        return calories
    }
    
    func createCalories(calories: Double, date: Date) {
        let newCalories = Calories(context: CoreDataStack.shared.mainContext)
        newCalories.calories = calories
        newCalories.date = date
        saveToPersistentStore()
    }
    
    func updateCalories(calorie: Calories, calories: Double) {
        calorie.calories = calories
        calorie.date = Date.init()
        saveToPersistentStore()
    }
    
    func deleteCalories(calories: Calories) {
        CoreDataStack.shared.mainContext.delete(calories)
        saveToPersistentStore()
    }
    
    func fetchPersistentStore(identifier: String, context: NSManagedObjectContext) -> Calories? {
        let request: NSFetchRequest<Calories> = Calories.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        request.predicate = predicate
        
        var calories: Calories?
        context.performAndWait {
            calories = (try? context.fetch(request))?.first
        }
        return calories
    }
}
