//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/14/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    func create(recordedCalories: Double) {
        Calorie(recordedCalories: recordedCalories)
        saveToPersistentStore()
    }
    
    func update(calories: Calorie, countedCalories: Double) {
        calories.recordedCalories += countedCalories
        saveToPersistentStore()
    }
    
    func delete(calorie: Calorie) {
        let moc = CoreDataStack.coreData.mainContext
        moc.delete(calorie)
        saveToPersistentStore()
    }
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.coreData.save()
            NotificationCenter.default.post(name: .caloriesCounted, object: nil)
        } catch {
            NSLog("Error saving moc: \(error)")
        }
    }
    
    var calories: [Calorie] {
        let fetch: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timeRecorded", ascending: true)]
        let moc = CoreDataStack.coreData.mainContext
        
        do {
            return try moc.fetch(fetch)
        } catch {
            NSLog("Error fetching from persistent store: \(error)")
            return []
        }
    }
}
