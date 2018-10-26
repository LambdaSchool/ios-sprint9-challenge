//
//  TestViewController.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import SwiftChart

class TestViewController: UIViewController, ChartDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChart()
        
    }
    

    func setUpChart() {
        let chart = Chart(frame: CGRect(x: 0, y: 300, width: 300, height: 200))
        chart.delegate = self
        let series = ChartSeries([0, 2, 5])
        series.area = true
        chart.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }

}
