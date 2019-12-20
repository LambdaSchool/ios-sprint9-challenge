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
    
    var chartData: [Double]
    var chartSeries: ChartSeries
    
    init() {
        self.chartData = [0]
        self.chartSeries = ChartSeries(chartData)
        self.chartSeries.color = ChartColors.greyColor()
    }
    
    func createEntry(calories: Float, timestamp: Date) {
        Entry(calories: calories, timestamp: timestamp)
        chartData.append(Double(calories))
        chartSeries = ChartSeries(chartData)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Error saving calorie entry \(error)")
        }
    }
    
    func deleteEntry(for entry: Entry) {
    
    }
}
