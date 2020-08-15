//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Elizabeth Thomas on 8/14/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet weak var chartView: Chart!
    var caloriesAdded: Calorie? {
        didSet {
            tableView.reloadData()
        }
    }
    var calories: [Calorie] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let calories = alertController.textFields![0]
            self.caloriesAdded?.calorieCount = calories.text ?? "Input number greater than 0"
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath) as? CalorieTrackerTableViewCell else { return UITableViewCell() }

        cell.calorieCountLabel.text = caloriesAdded?.calorieCount
        cell.timestampLabel.text = String(describing: Date())

        return cell
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
