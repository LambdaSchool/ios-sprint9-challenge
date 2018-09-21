//
//  CaloriesTableViewController.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class CaloriesTableViewController: UITableViewController {
    var calorieController = CalorieController()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.caloriesTracked.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTrackerCell", for: indexPath)
        
        let amount = String(calorieController.caloriesTracked[indexPath.row].amount)
        let date = dateFormatter.string(from: calorieController.caloriesTracked[indexPath.row].date ?? Date())
        
        cell.textLabel?.text = "Calories: \(amount)"
        cell.detailTextLabel?.text = date
        
        return cell
    }

    @IBAction func addCalories(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake",
            message: "Enter the amount of calories",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Calories"
        })

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text {
                self.calorieController.addCalories(amount: Int(calories) ?? 0)
                self.tableView.reloadData()
            }
        }))

        self.present(alert, animated: true)
    }
    

}
