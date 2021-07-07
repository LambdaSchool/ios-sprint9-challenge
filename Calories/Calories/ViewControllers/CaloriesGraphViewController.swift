//
//  CaloriesGraphViewController.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesGraphViewController: UIViewController
{
    var calorieController: CalorieController?
    {
        didSet
        {
            setupChart()
        }
    }
    
    var calorieValueArray = [Double]()
    
    let caloriesChart: Chart =
    {
        let chart = Chart(frame: .zero)
        chart.axesColor = .blue
        
        return chart
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(addDataToChart(notification:)), name: .newEntryWasCreated, object: nil)
    }
    
    private func setupChart()
    {
        guard let calories = calorieController?.calories else { return }
        for calorie in calories
        {
            calorieValueArray.append(Double(calorie.calories))
        }
        
        caloriesChart.add(ChartSeries(calorieValueArray))
    }
    
    @objc func addDataToChart(notification: NSNotification)
    {
        if let calorie = notification.userInfo?["calories"] as? Int16
        {
            calorieValueArray.append(Double(calorie))
            caloriesChart.add(ChartSeries(calorieValueArray))
        }
    }
    
    private func setupViews()
    {
        view.addSubview(caloriesChart)
        caloriesChart.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
}










