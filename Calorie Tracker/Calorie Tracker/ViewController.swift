//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import SwiftChart


// MARK: - Notification.Name Extension

extension Notification.Name {
    static let newCalorieEntryAdded = Notification.Name(rawValue: "newCalorieEntryAdded")
}


// MARK: - ViewController

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalorieEntryCell.self, forCellReuseIdentifier: "CalorieEntryCell")
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateViews(_:)), name: .newCalorieEntryAdded, object: nil)
    }
    
    
    // MARK: - Properties
    
    var chartView: Chart!
    var tableView: UITableView!
    var data = [(x: 0.0, y: 0.0)]
    var calorieEntryController = CalorieEntryController()
    let chartSeriesHelper = ChartSeriesHelper()
    
    
    // MARK: - Actions
    
    @IBAction func addCalorieEntry(_ sender: Any) {
        let calorieInputAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        var textField: UITextField!
        calorieInputAlert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calories = Double(textField.text ?? "0") ?? 0
            self.calorieEntryController.addCalorieEntry(calories)
            
            let nc = NotificationCenter.default
            nc.post(name: .newCalorieEntryAdded, object: self)
        }
        calorieInputAlert.addAction(cancelAction)
        calorieInputAlert.addAction(submitAction)
        
        self.present(calorieInputAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    
    @objc func updateViews(_ notification: Notification) {
        chartView.series = [chartSeriesHelper.convertToChartSeries(calorieEntries: calorieEntryController.calorieEntries)]
        tableView.reloadData()
    }
    
    
    // MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.calorieEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)
        
        let calorieEntry = calorieEntryController.calorieEntries[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(Int(calorieEntry.calories))"
        cell.detailTextLabel?.text = "Date"
        
        return cell
    }
}

