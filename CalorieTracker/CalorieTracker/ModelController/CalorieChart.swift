//
//  CalorieChart.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import SwiftChart

class CalorieChart: Chart {
    
    var chartSeries: [ChartSeries] = []
    
    func createGraphWith(calorie: Double) {
        let chartseries = ChartSeries([calorie])
        self.chartSeries.append(chartseries)
        
    }
    
    func graphChart() {
        self.add(chartSeries)
    }
}
