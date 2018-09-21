//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Linh Bouniol on 9/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController, UITableViewDataSource {

    var calorieController = CalorieController()
    
    var chartSeries = ChartSeries([])
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addCalorie(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = ""
            titleTextField.keyboardType = .numberPad
        }
        
        
        alert.addAction(UIAlertAction(title: "Sumbit", style: .default, handler: { (action) in
            guard let calorie = alert.textFields![0].text, calorie.count > 0 else { return }
            guard let calorieCount = Int64(calorie) else { return }
            self.calorieController.create(calorie: calorieCount)
            
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(calorieAdded), name: CalorieController.addedCalorieNotificaiton, object: nil)
        
        for calorie in calorieController.calories {
            chartSeries.data.append((x: Double(chartSeries.data.count), y: Double(calorie.calorie)))
        }
        
        chart.add(chartSeries)
    }
    
    @objc func calorieAdded(notification: Notification) {
        guard let calorieCount = notification.userInfo?["calorie"] as? Int64 else { return }
        chartSeries.data.append((x: Double(chartSeries.data.count), y: Double(calorieCount)))
        
        chart.setNeedsDisplay()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = calorieController.calories[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorie.calorie)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        
        if let timestamp = calorie.timestamp {
            cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        }
        
        return cell
    }

}

