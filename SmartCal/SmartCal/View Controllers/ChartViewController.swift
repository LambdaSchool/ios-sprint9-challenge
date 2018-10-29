//
//  ChartViewController.swift
//  SmartCal
//
//  Created by Farhan on 10/28/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import SwiftChart

class ChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 375, height: 150))
        
        let series1 = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series1.color = ChartColors.yellowColor()
        series1.area = true
        chart.add(series1)
        
        chart.sizeThatFits(CGSize(width: view.frame.width, height: view.frame.height))
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
