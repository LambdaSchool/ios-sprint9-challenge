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
    var caloriesAdded: Calorie?
    var calories: [Calorie] = []  {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let newCalories = alertController.textFields?[0].text ?? "Input number greater than 0"
            let calorie = Calorie(calorieCount: newCalories, timestamp: Date())
            self.caloriesAdded = calorie
            self.calories.append(calorie)
            
            let calorieNumber = Double(calorie.calorieCount)!
            
            let series = ChartSeries([calorieNumber])
            self.chartView.add(series)
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath) as? CalorieTrackerTableViewCell else { return UITableViewCell() }

        let calorie = calories[indexPath.row]
        cell.calorieCountLabel.text = calorie.calorieCount
        cell.timestampLabel.text = String(describing: calorie.timestamp)

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
