//
//  CalorieChartTableViewController.swift
//  CalorieTracker
//
//  Created by John Kouris on 12/14/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChartTableViewController: UITableViewController {
    
    @IBOutlet var chartView: Chart!
    
    var calorieLogs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalorieLog), name: .calorieLogChanged, object: nil)
        
        var series = ChartSeries([])
        
        for item in calorieLogs {
            series = ChartSeries([Double(item)!])
        }
        
        chartView.add(series)
    }
    
    @objc func updateCalorieLog() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieLogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)

        cell.textLabel?.text = calorieLogs[indexPath.row]

        return cell
    }

    @IBAction func addTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your calories here"
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textFieldEntry = alertController.textFields![0].text
            self.calorieLogs.append(textFieldEntry!)
            NotificationCenter.default.post(name: .calorieLogChanged, object: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
