//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    // MARK: - Layout
    
    override func loadView() {
        super.loadView()
        
        let chartView = Chart(frame: CGRect.zero)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chartView)
        
        let chartHeightMultiplyer: CGFloat = 0.45
        let chartWidthConstraint = NSLayoutConstraint(item: chartView, attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: self.view, attribute: .width,
                                                      multiplier: 1.0, constant: 0.0)
        let chartHeightContraint = NSLayoutConstraint(item: chartView, attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: self.view.safeAreaLayoutGuide, attribute: .height,
                                                      multiplier: chartHeightMultiplyer, constant: -16.0)
        let chartCenterXConstraint = NSLayoutConstraint(item: chartView, attribute: .centerX,
                                                        relatedBy: .equal,
                                                        toItem: self.view, attribute: .centerX,
                                                        multiplier: 1.0, constant: 0.0)
        let chartTopConstraint = NSLayoutConstraint(item: chartView, attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: self.view.safeAreaLayoutGuide, attribute: .top,
                                                    multiplier: 1.0, constant: 16.0)
        
        NSLayoutConstraint.activate([chartWidthConstraint,
                                     chartHeightContraint,
                                     chartCenterXConstraint,
                                     chartTopConstraint])
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        let tableViewWidthConstraint = NSLayoutConstraint(item: tableView, attribute: .width,
                                                          relatedBy: .equal,
                                                          toItem: self.view, attribute: .width,
                                                          multiplier: 1.0, constant: 0.0)
        let tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: self.view.safeAreaLayoutGuide, attribute: .height,
                                                           multiplier: 1-chartHeightMultiplyer, constant: -16.0)
        let tableViewCenterXConstraint = NSLayoutConstraint(item: tableView, attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: self.view, attribute: .centerX,
                                                            multiplier: 1.0, constant: 0.0)
        let tableViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: chartView, attribute: .bottom,
                                                        multiplier: 1.0, constant: 16.0)
        NSLayoutConstraint.activate([tableViewWidthConstraint,
                                     tableViewHeightConstraint,
                                     tableViewCenterXConstraint,
                                     tableViewTopConstraint])
        
        self.chartView = chartView
        chartView.add(ChartSeries(data: data))
        self.tableView = tableView
    }
    
    
    // MARK: - Properties
    
    var chartView: Chart!
    var tableView: UITableView!
    var data = [(x: 0.0, y: 0.0)]
    
    
    // MARK: - Actions
    
    @IBAction func addCalorieEntry(_ sender: Any) {
        
    }
}

