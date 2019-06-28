//
//  MealController.swift
//  CalorieTracker
//
//  Created by Jonathan Ferrer on 6/28/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import CoreData

class MealController {

    func createMeal(calories: Int) {
        let _ = Meal(calories: calories)
        saveToPersistentStore()
        NotificationCenter.default.post(name: .mealWasAdded, object: nil)
    }

    func loadFromPersistentStore() -> [Meal] {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            return try moc.fetch(fetchRequest)
        } catch  {
            NSLog("Error fetching meal: \(error)")
            return []
        }
    }

    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            print("Saved meal")
        } catch {
            NSLog("Error saving managed object contex: \(error)")
        }
    }

    var meals: [Meal] {
        let loadedData = loadFromPersistentStore()
        return loadedData
    }
}
