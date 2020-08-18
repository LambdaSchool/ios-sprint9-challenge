//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Elizabeth Thomas on 8/14/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet private var chartView: Chart!
    var caloriesAdded: Calorie?
    var calories: [Calorie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var graphNumbers: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
    }
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        alertAndGetCalories()
    }
    
    // MARK: - Functions
    func setupChart() {
        chartView.axesColor = .cyan
        chartView.highlightLineColor = .cyan
        chartView.highlightLineWidth = 1
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell",
                                                       for: indexPath) as? CalorieTrackerTableViewCell else {
                                                        return UITableViewCell() }

        let calorie = calories[indexPath.row]
        cell.calorie = calorie

        return cell
    }

}

extension CalorieTrackerTableViewController {
    
    func getTimestamp(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy  HH:mm"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    func alertAndGetCalories() {
        // Creating alert
        let alertController = UIAlertController(title: "Add Calorie Intake",
                                                message: "Enter the amount of calories",
                                                preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            // Getting input from text field
            let newCalories = alertController.textFields?[0].text ?? "Input number greater than 0"
            
            // Creating new instance of calorie
            let calorie = Calorie(calorieCount: newCalories, timestamp: self.getTimestamp(date: Date()))
            self.caloriesAdded = calorie
            self.calories.append(calorie)
            
            // Setting chart points
            let calorieNumber = Double(calorie.calorieCount)!
            self.graphNumbers.append(calorieNumber)
            
            // Adding chart points to chart
            let series = ChartSeries(self.graphNumbers)
            series.color = ChartColors.cyanColor()
            series.area = true
            self.chartView.add(series)
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
