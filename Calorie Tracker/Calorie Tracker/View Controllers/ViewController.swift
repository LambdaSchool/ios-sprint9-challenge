//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showChart()
    }

    func showChart() {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chart.add(series)
    }

}

