//
//  CaloriesTableViewController.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit

class CaloriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caloriesController.calories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caloriesCell", for: indexPath)

        let calories = caloriesController.calories[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(calories.calories)"
        
        if calories.formattedDate != nil {
            cell.detailTextLabel?.text = "\(calories.formattedDate!)"
        }

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let calories = caloriesController.calories[indexPath.row]
            caloriesController.deleteCalories(calories: calories)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    // MARK: - Properties
    var caloriesController = CaloriesController()
}
