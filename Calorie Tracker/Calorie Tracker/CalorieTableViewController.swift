//
//  CalorieTableViewController.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class CalorieTableViewController: UITableViewController {

    // MARK: - Properites
    var calorieController = CalorieController()

    // MARK: - Outlets

    // MARK: - Actions

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        askUserForCalorieCount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Private

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
                // FIXME: Get value out of here.
                print(calorieCount)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCountCell", for: indexPath)

        // Configure the cell...
        let calorieStr = "Calories: \(calorieController.entries[indexPath.row].calories)"
        // FIXME: Get a date formatter in here.
        let timeStr = "\(calorieController.entries[indexPath.row].timestamp!)"
        cell.textLabel?.text = "\(calorieStr) \(timeStr)"

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            calorieController.delete(entity: calorieController.entries[indexPath.row])
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
