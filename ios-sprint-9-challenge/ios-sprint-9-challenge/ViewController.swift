//
//  ViewController.swift
//  ios-sprint-9-challenge
//
//  Created by David Doswell on 9/21/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    let chart = Chart(frame: CGRect(x: 60, y: 300, width: 300, height: 200))
    let data = [
        (x: 0, y: 0),
        (x: 1, y: 3.1),
        (x: 4, y: 2),
        (x: 5, y: 4.2),
        (x: 7, y: 5),
        (x: 9, y: 9),
        (x: 10, y: 8)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }

    private func setUpViews() {
    
        view.backgroundColor = .white
        view.addSubview(chart)
        
        let series = ChartSeries(data: self.data)
        chart.add(series)
        
        

    }

}

