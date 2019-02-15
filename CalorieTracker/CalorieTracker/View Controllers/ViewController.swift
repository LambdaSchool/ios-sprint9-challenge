//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        series = ChartSeries(CalorieIntakeController.shared.caloriesArray)
        chart.add(series)
        NotificationCenter.default.addObserver(self, selector: #selector(caloriesArrayDidChange(_:)), name: .calorieIntakesDidChange, object: nil)
    }
    
    @objc func caloriesArrayDidChange(_ notification: Notification) {
        series = ChartSeries(CalorieIntakeController.shared.caloriesArray)
        chart.add(series)
    }

    var series: ChartSeries!

    @IBOutlet weak var chart: Chart!
}

