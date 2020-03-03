//
//  ChartSeriesHelper.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import SwiftChart

struct ChartSeriesHelper {
    
    func convertToChartSeries(calorieEntries: [CalorieEntry]) -> ChartSeries {
        var data: [(x: Double, y: Double)] = []
        var count = 0.0
        for calorieEntry in calorieEntries {
            let newData = (x: count, y: calorieEntry.calories)
            data.append(newData)
            count += 1
        }
        let series = ChartSeries(data: data)
        series.area = true
        return series
    }
    
}
