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
    
    var chart: Chart?
    var data = [Double]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chart = Chart(frame: CGRect(x: 0, y: 0, width: 375, height: 150))
        createChart(for: [320.5, 239.5, 400, 369])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .caloriesWereUpdated, object: nil)
        
    }
    
    @objc func updateChart() {
        NSLog("I'm LISTENING")
    }
    
    func createChart(for seriesData: [Double]){
        
        let series = ChartSeries(seriesData)
        series.color = ChartColors.darkGreenColor()
        series.area = true
        chart?.add(series)
//        chart.sizeThatFits(CGSize(width: view.frame.width, height: view.frame.height))
        view.addSubview(chart!)
        
    }
    
    //TODO:
    // Create notification shouter in table view
    // create notification listener here
    
    

}
