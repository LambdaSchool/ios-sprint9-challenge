//
//  CaloriesController.swift
//  S9 Calorie Tracker
//
//  Created by Angel Buenrostro on 3/17/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class CaloriesController {
    
    var calories: [Calories] = []
    
    init() {
        
//        createCalories(calorieAmount: "100")
        guard let calorieArray = fetchCaloriesFromPersistentStore() else { return }
        calories = calorieArray
    }
    
    func fetchCaloriesFromPersistentStore(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Calories]? {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        
        var calories: [Calories]?
        
        context.performAndWait {
            do{
                calories = try context.fetch(fetchRequest)
            } catch {
                NSLog("Error fetching calories")
            }
        }
        return calories
    }
    
    func saveToPersistentStore(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    func createCalories(calorieAmount: String){
        let _ = Calories(calorieAmount: calorieAmount)
        saveToPersistentStore()
    }
    
    func deleteAllCalories(){
        calories = []
        saveToPersistentStore()
    }
    
    func deleteCalories(index: Int){
        calories.remove(at: index)
        saveToPersistentStore()
    }
}
