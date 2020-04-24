//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Christopher Devito on 4/24/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    let calorieEntryController = CalorieEntryController()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryController.loadFromPersistentStore()
        updateViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .addCalorieEntry, object: nil)
    }
    
    @objc func refreshViews(_ notifications: Notification) {
        updateViews()
    }
    
    func updateViews() {
        tableView.reloadData()
    }
    
    // MARK: - Outlet
    @IBOutlet private weak var calorieChart: Chart!
    
    // MARK: - Actions
    
    @IBAction func addCalorientry(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in this field", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calories: "
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0]
            guard let caloriesString = textField?.text, let calories = Int(caloriesString) else {
                return }
            self.calorieEntryController.createCalorieEntry(calories: calories)
            NotificationCenter.default.post(name: .addCalorieEntry, object: self.calorieEntryController)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.calorieEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)

        let calorieEntry = calorieEntryController.calorieEntries[indexPath.row]
        let timestamp = calorieEntry.timestamp ?? Date()
        cell.textLabel?.text = "Calories: \(calorieEntry.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    */

}
