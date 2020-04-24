//
//  CalorieTableViewController.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit
import SwiftChart

extension NSNotification.Name {
    static let shouldUpdateGraph = NSNotification.Name("shouldUpdateGraph")
}

class CalorieTableViewController: UITableViewController {

    // MARK: - Properites
    var calorieController = CalorieController()

    // MARK: - Outlets

    @IBOutlet private weak var calorieChart: Chart!

    // MARK: - Actions

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        askUserForCalorieCount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .shouldUpdateGraph, object: nil)

        updateViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViews()
    }

    @objc func refreshViews(_ notification: Notification) {
        if notification.name == .shouldUpdateGraph {
            updateViews()
        }
    }

    // MARK: - Private
    private func updateViews() {
        tableView.reloadData()

        calorieChart.removeAllSeries()

        let calorieData = ChartSeries(calorieController.entries.map({ Double($0.calories) }))

        // Color in the graph
        calorieData.area = true

        // Specify colors for the graph
        calorieData.colors = (
            above: ChartColors.blueColor(),
            below: ChartColors.yellowColor(),
            zeroLevel: 0
        )
        calorieChart.add(calorieData)
    }

    private func askUserForCalorieCount() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)

        var calorieCountTextField: UITextField!
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            calorieCountTextField = textField
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            let calorieCountStr = calorieCountTextField.text ?? "NaN"
            let calorieCount = Int(calorieCountStr)
            if let calorieCount = calorieCount {
                self.calorieController.create(calories: calorieCount, timestamp: Date())
            } else {
                print("Invalid user input to calorieCount.")
            }
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCountCell",
                                                       for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        cell.entity = calorieController.entries[indexPath.row]

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            calorieController.delete(entity: calorieController.entries[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
