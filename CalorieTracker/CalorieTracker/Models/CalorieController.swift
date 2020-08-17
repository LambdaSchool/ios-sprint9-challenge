//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/17/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    var calorie: Calorie?
    
    var caloriesRecorded: [Calorie] {
        
        let fetch: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timeRecorded", ascending: true)]
        
        let moc = CoreDataStack.coreData.mainContext
        
        do {
            return try moc.fetch(fetch)
        } catch {
            NSLog("Error fetching data: \(error)")
            return []
        }
    }
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.coreData.save()
            NotificationCenter.default.post(name: .caloriesCounted, object: nil)
        } catch {
            NSLog("Error saving moc: \(error)")
        }
    }
    
    func createEntry(calorieRecorded: Double) {
        Calorie(caloriesRecorded: calorieRecorded)
        saveToPersistentStore()
    }
    
    func deleteEntry(calorie: Calorie) {
        let moc = CoreDataStack.coreData.mainContext
        moc.delete(calorie)
        saveToPersistentStore()
    }
    
    func updateExistingEntry(calorie: Calorie, incomingCalories: Double) {
        calorie.caloriesRecorded += incomingCalories
        saveToPersistentStore()
    }
}
