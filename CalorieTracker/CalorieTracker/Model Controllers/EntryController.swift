//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_204 on 12/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import SwiftChart

class EntryController {

    private var xAxisCount: Double = 0

    func createEntry(calories: Float, timestamp: Date) {
        Entry(calories: calories, timestamp: timestamp)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Error saving calorie entry \(error)")
        }
    }

    func deleteEntry(for entry: Entry) {

    }

    func dataToChartSeries(for calories: Float) -> (Double, Double) {
        let data = (xAxisCount, Double(calories))
        xAxisCount += 1
        return data
    }
}
