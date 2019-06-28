//
//  CaloriesTableViewController.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

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
    
    // MARK: - Alert Controller
    func showAlertController() {
        let alertController = UIAlertController(title: "Add Calories", message: "Enter the amount of calories", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calories = alertController.textFields?[0].text
            let caloriesDouble = Double(calories ?? "0")
            self.caloriesController.createCalories(calories: caloriesDouble!, date: Date())
            NotificationCenter.default.post(name: .showChartDataChanged, object: self)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlertController()
    }
    
    // MARK: - IBOUtlets
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Properties
    var caloriesController = CaloriesController()
}
