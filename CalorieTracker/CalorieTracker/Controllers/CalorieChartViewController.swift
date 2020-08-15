//
//  CalorieChartViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/14/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class CalorieChartViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(chart), name: .caloriesCounted, object: nil)
    }
    
    @objc func chart() {
        
        if !chartView.series.isEmpty { chartView.removeAllSeries() }
        
        let calories = recordController.records.map({ Double($0.calorieCount) })
        
        let series = ChartSeries(calories)
        series.color = UIColor(red: 0.0 / 255.0, green: 176.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        series.area = true
        
        chartView.add(series)
    }

}
