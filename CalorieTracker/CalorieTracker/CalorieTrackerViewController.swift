//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by David Wright on 5/3/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    var calorieDataPoints = [CalorieDataPoint]()
    
    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        showCalorieIntakeAlert()
    }
    
    private func showCalorieIntakeAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textFields = alert.textFields,
                let caloriesString = textFields[0].text,
                !caloriesString.isEmpty,
                let calories = Int(caloriesString) else { return }
            self.addCalories(calories: calories)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            textField.keyboardType = .numberPad
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addCalories(calories: Int) {
        let timestamp = Date()
        let calorieDataPoint = CalorieDataPoint(calories: calories, timestamp: timestamp)
        calorieDataPoints.append(calorieDataPoint)
        updateViews()
    }
    
    private func updateChart() {
        let calorieData = calorieDataPoints.compactMap { Double($0.calories) }
        let series = ChartSeries(calorieData)
        series.area = true
        calorieChart.add(series)
    }
    
    private func updateViews() {
        tableView.reloadData()
        updateChart()
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieDataPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieDataPointCell", for: indexPath)
        let calories = calorieDataPoints[indexPath.row].calories
        let timestamp = calorieDataPoints[indexPath.row].timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a"
        
        cell.textLabel?.text = "Calories: \(calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    
}
