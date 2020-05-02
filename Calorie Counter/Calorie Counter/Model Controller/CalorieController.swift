//
//  CalorieController.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart


class CalorieController {
    
    var calorieEntries: [Calorie] = []
    var calories: [Double] = []
    
    func delete(for calories: Calorie) {
        let context = CoreDataStack.shared.mainContext
        context.delete(calories)
        try? context.save()
        guard let index = calorieEntries.firstIndex(of: calories) else {return}
        calorieEntries.remove(at: index)
//        CoreDataStack.shared.mainContext.delete(calories)
    }
    
    func loadFromPersistentStore() {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        context.performAndWait {
            do {
                let oldEntries = try context.fetch(fetchRequest)
                calorieEntries = oldEntries
            } catch {
                print("Error Fetching calorie entries: \(error)")
            }
        }
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving Managed Object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func addCalorieEntry(calories: Double) -> [Double] {
        var caloriesArray: [Double] = []
        caloriesArray.append(calories)
        return caloriesArray
        
        //TODO Notification observers will go here
        
    }
}
