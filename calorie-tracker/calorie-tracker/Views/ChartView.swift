//
//  Chart.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import SwiftChart

class ChartView: UIView {

    var chartView: Chart!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initial setup of chart view
        setupChartView()
        
        // Listen to notifications whenever the chart should be updated
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateChartView(_:)), name: .updateChart, object: nil)
    }
    
    private func setupChartView() {
        chartView = Chart(frame: CGRect.zero)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartView)
        
        let constraints: [NSLayoutConstraint] = [
            chartView.topAnchor.constraint(equalTo: self.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func updateChartView(_ notification: Notification) {
        
        if let caloriesByPerson = notification.object as? [String : [CalorieIntake]] {
            
            for person in caloriesByPerson {
                let calorieSeries = getCalorieSeries(for: person.value)
                let series = ChartSeries(calorieSeries)
                series.area = true
                series.colors = (
                    above: ChartColors.greenColor(),
                    below: ChartColors.redColor(),
                    zeroLevel: -1
                )
                
                chartView.add(series)
            }
            
        }
    }
    
    private func getCalorieSeries(for calorieIntake: [CalorieIntake]) -> [Double] {
        return calorieIntake.map { Double($0.calorie) }
    }

}
