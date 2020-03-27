//
//  CalorieChartView.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import SwiftChart

class CalorieChartView: Chart {
    
    private(set) var chartSeries: [Double] = []
    
    init() {
        super.init(frame: .zero)
        
        let series = ChartSeries(chartSeries)
        series.area = true
        add(series)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSeries(values: [Double]) {
        chartSeries.append(contentsOf: values)
        let newseries = ChartSeries(values)
        newseries.area = true
        series[0] = newseries
    }
    
    private func addSeriesToChart(newseries: ChartSeries) {
        
    }
    
}
