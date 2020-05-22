//
//  TotalCaloriesTableViewController.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import SwiftChart

class TotalCaloriesTableViewController: UITableViewController {
    
    var caloriesController = CaloriesController()
    @IBOutlet private weak var caloriesChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: .whenUpdateGraph, object: nil)
       updateViews()
    }
    @objc func reloadViews(_ notification: Notification) {
        if notification.name == .whenUpdateGraph {
            updateViews()
        }
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //        alert controller with textfield
        let alert = UIAlertController(title: "Calories", message: "Amount of the calories", preferredStyle: .alert)
        var caloriesTextField: UITextField!
        alert.addTextField { textField in
            textField.placeholder = "Amount of Calories"
            caloriesTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            //        Converting stirng calories in integer.
            let stringCalorieCount = caloriesTextField.text ?? ""
            let caloriesInt = Int(stringCalorieCount)
            if let caloriesInt = caloriesInt {
              self.caloriesController.createCalories(calories: caloriesInt, timestamp: Date())
            } else {
                print("Not a calorie")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func updateViews() {
        caloriesChart.removeAllSeries()
        let series = ChartSeries(caloriesController.calories.map({ Double($0.calories) }))
        series.area = true
        series.colors = (
            above: ChartColors.greenColor(),
            below: ChartColors.yellowColor(),
            zeroLevel: 0
        )
        caloriesChart.add(series)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caloriesController.calories.count
    }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalCell", for: indexPath) as? CaloriesTableViewCell else { return UITableViewCell() }
     // Configure the cell...
        cell.calories = caloriesController.calories[indexPath.row]
     return cell
     }
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        let calories = caloriesController.calories[indexPath.row]
     // Delete the row from the data source
        caloriesController.deleteCalories(calories: calories)
     }
     }
}
