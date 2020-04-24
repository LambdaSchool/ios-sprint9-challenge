//
//  CalorieTrackerChartViewController.swift
//  CalorieTracker
//
//  Created by Shawn Gee on 4/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftChart
import UIKit

class CalorieTrackerChartViewController: UIViewController {
    
    // MARK: - Private Properties
    private var chartView: Chart!
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        chartView = Chart(frame: .zero)
        view = chartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
