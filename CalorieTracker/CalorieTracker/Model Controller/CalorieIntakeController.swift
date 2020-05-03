//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

class CalorieIntakeController {

    init() {
        loadFromPersistentStore()
    }
    
    private(set) var listOfIntakes: [CalorieIntake] = []
    var listOfCalories: [Double] {
        var list: [Double] = [0]
        for item in listOfIntakes {
            list.append(item.calories)
        }
        return list
    }

    func createIntake(withCalories: Double) {
        let intake = CalorieIntake(calories: withCalories)
        listOfIntakes.append(intake)
        saveToPersistentStore()
    }

    func delete(intake: CalorieIntake) {
        CoreDataStack.shared.mainContext.delete(intake)
        saveToPersistentStore()
    }

    func loadFromPersistentStore() -> [CalorieIntake] {

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "calories == %@", Double())
        let moc = CoreDataStack.shared.mainContext

        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching from moc: \(error)")
            return []
        }
    }

    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
