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
        self.chartSeries.colors.below = ChartColors.blueColor()
    }

    func createEntry(calories: Float, timestamp: Date) {
        Entry(calories: calories, timestamp: timestamp)
        chartData.append(Double(calories))
        addDataToChartSeries()
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Error saving calorie entry \(error)")
        }
    }

    func deleteEntry(for entry: Entry) {

    }

    private func addDataToChartSeries() {
        var data = [(Double, Double)]()

        for index in 0..<chartData.count {
            let axis = (Double(index), chartData[index])
            data.append(axis)
        }

        chartSeries = ChartSeries(data: data)
    }
}
