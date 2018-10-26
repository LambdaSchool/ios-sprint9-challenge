//
//  CaloriesTableViewController.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dailyIntakeController.dailyIntakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyIntakeCell", for: indexPath)
        
        let dailyIntake = dailyIntakeController.dailyIntakes[indexPath.row]
        cell.textLabel?.text = String(dailyIntake.calories)
        cell.detailTextLabel?.text = dateFormatter.string(for: dailyIntake.date)

        return cell
    }
    
    @IBAction func addIntake(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (alertAction) in
            guard let textField = alert.textFields?.first, let caloriesString = textField.text else { return }
            
            let calories = Int(caloriesString) ?? 0
            self.dailyIntakeController.add(calories: calories)
        }))
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var chartView: UIView!
    
    let dailyIntakeController = DailyIntakeController()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }()
}
