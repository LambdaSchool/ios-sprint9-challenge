//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Morgan Smith on 8/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

class CalorieTrackerController {

    private (set) var countedCalories: [Calories] = []

    func save(_ calorie: Calories) throws {
        try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        countedCalories.append(calorie)
    }

    func fetchCalories() {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: CoreDataStack.shared.mainContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)

        context.performAndWait {
            do {
                try fetchResultController.performFetch()
                countedCalories = fetchResultController.fetchedObjects ??  []

            } catch {
                NSLog("Error fetching results from store: \(error)")
            }
        }
    }

    var getXLabels: [Double] {
        guard !countedCalories.isEmpty else  { return [0] }
        var arr: [Double] = []
        for i in 0...countedCalories.count - 1 {
            arr.append(Double(i))
        }
        return arr
    }

    var getYLabels: [Double] {
        guard !countedCalories.isEmpty else  { return [0] }
        var big: Double = 0
        let first: Double = countedCalories[0].calorieCount
        for t in countedCalories {
            let i = t.calorieCount
            if Double(i) > big { big = Double(i) }
        }

        return [first, big/2, big]
    }

    var getData: [(x: Double, y: Double)] {
        var data: [(x: Double, y: Double)] = []

        for (i, calories) in countedCalories.enumerated() {
                data.append((x: Double(i), y: calories.calorieCount))
        }
        return data
    }

}
