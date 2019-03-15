//
//  ChartViewController.swift
//  CalorieTracker
//
//  Created by Nathanael Youngren on 3/15/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(newCalorie(_:)), name: .newCalorieAmountAdded, object: nil)
    }
    
    @objc func newCalorie(_ notification: NSNotification) {
        
        guard let parent = parent as? CalorieTrackerTableViewController else { return }
        
        let entries = parent.entryController.entries
        
        let calories = entries.map { Double($0.amountOfCalories) }
        
        self.calories = calories
    }
    
    func setUpChart() {
        guard let calories = calories else { return }
        
        let width: CGFloat = view.bounds.width - 16
        let height: CGFloat = 250
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let chart = Chart(frame: frame)
        let series = ChartSeries(calories)
        series.color = ChartColors.blueColor()
        chart.add(series)
        
        view.addSubview(chart)
    }
    
    var calories: [Double]? {
        didSet {
            setUpChart()
        }
    }
}
