//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Kobe McKee on 6/28/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let calorieLogController = CalorieLogController()

    
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if !calorieLogController.calorieLogs.isEmpty {
            refreshViews()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: .calorieAdded, object: nil)
        
    }
    
    
    
    @objc func refreshViews() {
        
        let calories = calorieLogController.calorieLogs.map { $0.calories }
        let formattedCalories = calories.map { Double($0) }
        var calorieData: [(x: Double, y: Double)] = []
        
        for (index, cal) in formattedCalories.enumerated() {
            var calorieCoord = (x: 0.0, y: 0.0)
            calorieCoord.x = Double(index)
            calorieCoord.y = cal
            calorieData.append(calorieCoord)
        }
        
        let series = ChartSeries(data: calorieData)
        chartView.add(series)
        
        tableView.reloadData()
    }

    
    
    
    
    // MARK: - Add Calorie Log
    
    
    @IBAction func addLog(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            guard let calorieCount = alert.textFields?.first?.text else { return }
            self.calorieLogController.logCalories(calories: calorieCount)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        refreshViews()
        
    }
    
    
    // MARK: - TableView Data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieLogController.calorieLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let log = calorieLogController.calorieLogs[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: log.logDate ?? Date())
    
        
        cell.textLabel?.text = ("Calories: \(log.calories)")
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    


}
