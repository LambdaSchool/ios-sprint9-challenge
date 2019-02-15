//
//  ChartViewController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chart.add(series)
        view.addSubview(chart)
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
