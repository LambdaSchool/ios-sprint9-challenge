//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Harmony Radley on 6/19/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

class CalorieTrackerController {

    func createCalorie(calorieAmount: Int,
                date: Date = Date(),
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        _ = Calorie(calorieAmount: calorieAmount, date: date, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .chartUpdate, object: nil)
            } catch {
                print("Unable to save new Calorie: \(error)")
                context.reset()
            }
        }
    }

    func deleteCalorie(calorie: Calorie,
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(calorie)
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .chartUpdate, object: nil)
            } catch {
                print("Could not save after deleted: \(error)")
                context.reset()
            }
        }
    }
}
