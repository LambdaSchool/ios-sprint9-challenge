//
//  CaloriesTableViewController.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesTableViewController: UITableViewController, ChartDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpChart()
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .didAddCalorie, object: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyIntakeController.dailyIntakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyIntakeCell", for: indexPath)
        
        let dailyIntake = dailyIntakeController.dailyIntakes[indexPath.row]
        cell.textLabel?.text = "Calories: \(dailyIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(for: dailyIntake.date)

        return cell
    }
    
    @IBAction func addIntake(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (alertAction) in
            guard let textField = alert.textFields?.first, let caloriesString = textField.text else { return }
            
            let calories = Int(caloriesString) ?? 0
            self.dailyIntakeController.add(calories: calories)
            
            self.tableView.reloadData()
            
            NotificationCenter.default.post(name: .didAddCalorie, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Swift Chart
    
    func setUpChart() {
        chart = Chart(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: chartView.frame.height))
        chart.delegate = self
        chartView.addSubview(chart)
        
        // Create data set for chart.
        let calories = dailyIntakeController.dailyIntakes.compactMap { (dailyIntake) -> Double? in
            return Double(dailyIntake.calories)
        }
        let series = ChartSeries(calories)
        series.area = true
        chart.add(series)
    }
    
    @objc func updateChart(_ notification: Notification) {
        chart.series = []
        let calories = dailyIntakeController.dailyIntakes.compactMap { (dailyIntake) -> Double? in
            return Double(dailyIntake.calories)
        }
        let series = ChartSeries(calories)
        series.area = true
        chart.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var chartView: UIView!
    
    private var chart: Chart = Chart(frame: .zero)
    private let dailyIntakeController = DailyIntakeController()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
}

extension Notification.Name {
    static let didAddCalorie = Notification.Name("DidAddCalorie")
}
