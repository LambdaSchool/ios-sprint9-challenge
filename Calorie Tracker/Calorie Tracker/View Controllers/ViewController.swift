//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Scott Bennett on 10/26/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController, ChartDelegate {

    
    @IBOutlet weak var chart: Chart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        
        
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chart.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }


}

