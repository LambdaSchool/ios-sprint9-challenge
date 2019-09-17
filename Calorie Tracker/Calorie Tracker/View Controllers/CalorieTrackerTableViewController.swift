//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Michael Stoffer on 9/14/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit
import SwiftChart

extension Notification.Name {
    static var updateChart = Notification.Name("updateChart")
}

class CalorieTrackerTableViewController: UITableViewController {

    @IBOutlet var ChartUIView: UIView!
    
    let calorieController = CalorieController()
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)
    }
    
    @objc func updateChart(notification: Notification) {
//        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 250))
//        // Create a new series specifying x and y values
//        let data = [
//            (x: 0, y: 0),
//            (x: 1, y: 3.1),
//            (x: 4, y: 2),
//            (x: 5, y: 4.2),
//            (x: 7, y: 5),
//            (x: 9, y: 9),
//            (x: 10, y: 8)
//        ]
//        let series = ChartSeries(data: data)
//        chart.add(series)
//        self.ChartUIView.addSubview(chart)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calorieController.calories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorie = self.calorieController.calories[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorie.calories ?? "0")"
        
        cell.detailTextLabel?.text = "\(calorie.created ?? Date())"

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
    
    @IBAction func AddCalorieButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Calories:"
        }
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let calorieCount = firstTextField.text else { return }
            self.calorieController.createCalorie(withCalorieCount: calorieCount)
            NotificationCenter.default.post(name: .updateChart, object: self)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
