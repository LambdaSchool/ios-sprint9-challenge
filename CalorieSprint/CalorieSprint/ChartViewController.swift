//
//  ChartViewController.swift
//  CalorieSprint
//
//  Created by Ryan Murphy on 6/28/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController {
    
    var chart: Chart?
    var series: ChartSeries?
    
    var calories: [Double]? {
        didSet {
            setUpChart()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(newCalorie(_:)), name: .calorieAmountAdded, object: nil)
    }
    
    @objc func newCalorie(_ notification: NSNotification) {
        
        guard let parent = parent as? CalorieTableViewController else { return }
        let entries = parent.entryController.entries
        let calories = entries.map { Double($0.numberOfCalories) }
        self.calories = calories
    }
    
    func setUpChart() {
        guard let calories = calories else { return }
        chart?.removeFromSuperview()
        
        let width: CGFloat = view.bounds.width - 20
        let height: CGFloat = 250
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        chart = Chart(frame: frame)
        series = ChartSeries(calories)
        series!.color = ChartColors.cyanColor()
        chart!.add(series!)
        view.addSubview(chart!)
    }
    
    
}


