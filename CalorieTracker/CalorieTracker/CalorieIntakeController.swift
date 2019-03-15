//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Julian A. Fordyce on 3/15/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import CoreData


class CalorieIntakeController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save()
        } catch {
            fatalError("Error saving to core data: \(error)")
        }
    }
    
    func loadFromPersistentStore() -> [CalorieIntake] {
        var caloriesIntake: [CalorieIntake] {
            do {
                let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
                let result = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
                return result
            } catch {
                fatalError("Can't fetch data \(error)")
            }
        }
        return caloriesIntake
    }
    
    func fetchPersistentStore(identifier: String, context: NSManagedObjectContext) -> CalorieIntake? {
        let request: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        request.predicate = predicate
        
        var calorieIntake: CalorieIntake?
        context.performAndWait {
            calorieIntake = (try? context.fetch(request))?.first
        }
        return calorieIntake
    }
    
    func createIntake(calories: Double, timestamp: Date) {
        let newIntake = CalorieIntake(context: CoreDataStack.shared.mainContext)
        newIntake.calories = calories
        newIntake.timestamp = timestamp
        saveToPersistentStore()
    }
    
    func deleteIntake(calorieIntake: CalorieIntake) {
        CoreDataStack.shared.mainContext.delete(calorieIntake)
        saveToPersistentStore()
    }
    
    func updateIntake(calorieIntake: CalorieIntake, calories: Double) {
        calorieIntake.calories = calories
        calorieIntake.timestamp = Date.init()
        saveToPersistentStore()
    }
    
    
    // MARK: - Properties
    
    var caloriesIntake: [CalorieIntake] {
        return loadFromPersistentStore()
    }
}

