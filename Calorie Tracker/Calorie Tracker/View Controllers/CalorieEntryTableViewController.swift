//
//  CalorieEntryTableViewController.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieEntryTableViewController: UITableViewController {
    
    // MARK: - Properties:
    
    var calorieController = CalorieController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        addEntryAlert()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var chart: Chart!
    
    // MARK: - Private Methods
    
    private func setupCell(for cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        guard let date = calorieController.calorieEntries[indexPath.row].date else { return UITableViewCell()}
        let entry = calorieController.calorieEntries[indexPath.row]
        
        let calorieCount = Int(entry.count)
        
        let titleString = "\(calorieCount) calories"
        let dateString = Date.getFormattedDate(date: date)
        
        cell.textLabel?.text = titleString
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    private func updateChart() {
        var chartEntries: [Double] = []
        
        for entry in calorieController.calorieEntries {
            let double = Double(entry.count)
            chartEntries.append(double)
        }
        
        let series = ChartSeries(chartEntries)
        chart.add(series)
    }
    private func addEntryAlert() {
        
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textfield) in
            textfield.placeholder = "Input caloric intake here"
        })
        let textFields = alert.textFields
        let alertTextField = textFields![0]
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: .default,
                                      handler: { action in
                                        guard let inputCalories = alertTextField.text,
                                            !inputCalories.isEmpty,
                                            let caloriesInt = Int(inputCalories) else { return }
                                        self.calorieController.createEnry(withCalorieCount: caloriesInt)
                                        self.updateChart()
                                        self.tableView.reloadData()
        }))
        
        present(alert, animated: true)
        
        return
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.calorieEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        return setupCell(for: cell, at: indexPath)
    }
    
}

