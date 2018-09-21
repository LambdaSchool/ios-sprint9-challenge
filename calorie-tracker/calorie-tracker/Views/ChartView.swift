//
//  Chart.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import SwiftChart

class ChartView: UIView {

    var chartView: Chart!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nc = NotificationCenter.default
        setupChartView()
        nc.addObserver(self, selector: #selector(updateChartView(_:)), name: .updateChart, object: nil)
        //setupChartView(_:)
    }
    
    private func setupChartView() {
        chartView = Chart(frame: CGRect.zero)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartView)
        
        let constraints: [NSLayoutConstraint] = [
            chartView.topAnchor.constraint(equalTo: self.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func updateChartView(_ notification: Notification) {
        if let object = notification.object as? [Double] {
            let chartSeries = ChartSeries(object)
            chartView.add(chartSeries)
        }
    }

}
