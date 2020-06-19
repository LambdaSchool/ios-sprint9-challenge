//
//  CalorieTableViewController.swift
//  Calorie Tracker
//
//  Created by Vincent Hoang on 6/19/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let notification = NSNotification.Name(rawValue: "reload")

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var chart: Chart!

    var dateFormatter: DateFormatter = DateFormatter()

    var meals: [Meal] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        setUpDateFormatter()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: notification, object: nil)
    }

    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)

        let selectedMeal = meals[indexPath.row]

        let caloriesLabel = "Calories: \(selectedMeal.calories)"
        let dateLabel = "\(dateFormatter.string(from: selectedMeal.date))"

        cell.textLabel?.text = caloriesLabel
        cell.detailTextLabel?.text = dateLabel

        return cell
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
        setUpChart()
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        entryPrompt()
    }

    // MARK: - Helper Functions
    private func entryPrompt() {
        let alert = UIAlertController(
            title: "Add Calorie Intake",
            message: "Enter the amount of calories in the field",
            preferredStyle: .alert)

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Calories"
            textField.keyboardType = .numberPad
        })

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(
            UIAlertAction(title: "Submit", style: .default, handler: { _ in
                guard let input = alert.textFields?[0].text else { return }
                self.meals.append(Meal(calories: Int(input) ?? 0))
                NotificationCenter.default.post(name: self.notification, object: nil)
            }))

        present(alert, animated: true, completion: nil)
    }

    private func setUpDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }

    // MARK: - SwiftChart
    private func setUpChart() {
        let data = meals.map { Double($0.calories) }
        let series = ChartSeries(data)
        series.area = true

        var xLabels: [Int] = []
        xLabels.append(contentsOf: 0...meals.count)

        chart.xLabels = xLabels.map { Double($0) }
        chart.xLabelsSkipLast = false
        chart.xLabelsTextAlignment = .left

        chart.add(series)
        chart.minY = 0

        let chartMaxY = Double(findMaxY(calories: findMaxCalories()))
        chart.maxY = chartMaxY
    }

    private func findMaxCalories() -> Int {
        var max = 0

        for meal in meals where meal.calories > max {
            max = meal.calories
        }

        return max
    }

    private func findMaxY(calories: Int) -> Int {
        if calories < 500 {
            return 500
        }

        var increment = 1000

        while increment / calories == 0 {
            increment += 500
        }

        return increment
    }

}
