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

    var listOfIntakes: [CalorieIntake] {
        //swiftlint:disable:next implicit_return
        return loadFromPersistentStore()
    }

    func createIntake(withCalories: Int16) {
        _ = CalorieIntake(calories: withCalories, time: Date())
        saveToPersistentStore()
    }

    func delete(intake: CalorieIntake) {
        CoreDataStack.shared.mainContext.delete(intake)
        saveToPersistentStore()
    }

    func loadFromPersistentStore() -> [CalorieIntake] {

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "date == %@", Date() as CVarArg)
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
