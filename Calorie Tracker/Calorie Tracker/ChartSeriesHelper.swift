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
        var data: [(x: Double, y: Double)] = [(x: 0, y: 0)]
        var count = 1.0
        for calorieEntry in calorieEntries {
            let newData = (x: count, y: calorieEntry.calories)
            data.append(newData)
            count += 1
        }
        return ChartSeries(data: data)
    }
    
}
