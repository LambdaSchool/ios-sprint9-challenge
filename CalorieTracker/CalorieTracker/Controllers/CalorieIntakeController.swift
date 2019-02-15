//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

extension Notification.Name {
    static let calorieIntakesDidChange = Notification.Name("calorieIntakesDidChange")
}

class CalorieIntakeController {
    
    static let shared = CalorieIntakeController()
    
    func loadFromPersistentStore() -> [CalorieIntake] {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        var results = [CalorieIntake]()
        CoreDataStack.shared.mainContext.performAndWait {
            results = try! fetchRequest.execute()
        }
        return results
        
    }
    
    func saveToPersistentStore(context: NSManagedObjectContext) {
        
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func createCalorieIntake(calories: Double, user: String?) {
        let newCalorieIntake = CalorieIntake(calories: calories, timestamp: Date.init(), identifier: UUID.init().uuidString, user: user, insertInto: CoreDataStack.shared.mainContext)
        saveToPersistentStore(context: CoreDataStack.shared.mainContext)

        calorieIntakesArray.append(newCalorieIntake)
    }
    
    
    
    
    
    
    
    
    
    var calorieIntakesArray: [CalorieIntake] = [] {
        didSet {
            caloriesArray.append((calorieIntakesArray.last?.calories)!)
            calorieIntakesArrayWasUpdated = true
        }
    }
    var caloriesArray: [Double] = []
    var calorieIntakesArrayWasUpdated: Bool {
        set {
            NotificationCenter.default.post(name: .calorieIntakesDidChange, object: self)
        }
        get {
            return self.calorieIntakesArrayWasUpdated
        }
    }
}
