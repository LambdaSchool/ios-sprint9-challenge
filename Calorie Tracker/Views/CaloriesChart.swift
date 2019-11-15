//
//  CaloriesChart.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import SwiftChart

class CaloriesChart: Chart {
    
//    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//
//    let data = [
//      (x: 0, y: 0),
//      (x: 3, y: 2.5),
//      (x: 4, y: 2),
//      (x: 5, y: 2.3),
//      (x: 7, y: 3),
//      (x: 8, y: 2.2),
//      (x: 9, y: 2.5)
//    ]
    
    func addProperties() {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let data = [
          (x: 0, y: 0),
          (x: 3, y: 2.5),
          (x: 4, y: 2),
          (x: 5, y: 2.3),
          (x: 7, y: 3),
          (x: 8, y: 2.2),
          (x: 9, y: 2.5)
        ]
        let series = ChartSeries(data: data)
        series.area = true

        // Use `xLabels` to add more labels, even if empty
        chart.xLabels = [0, 3, 6, 9, 12, 15, 18, 21, 24]

        // Format the labels with a unit
        chart.xLabelsFormatter = { String(Int(round($1))) + "h" }

        chart.add(series)
//        var mySeries = ChartSeries(data: data)
//        mySeries.area = true
//        chart.add(mySeries)
        
        
    }
    
    
    
}
