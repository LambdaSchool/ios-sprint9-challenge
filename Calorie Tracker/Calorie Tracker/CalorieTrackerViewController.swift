//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let calorieEntryController = CalorieEntryController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryController.fetchCalorieEntries { (_) in
            tableView.reloadData()
        }
    }
    @IBAction func addCalorieEntryButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Entry",
                                      message: "Please enter the number of calories in the text field",
                                      preferredStyle: .alert)
        alert.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Number of Calories"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let calorieString = alert.textFields![0].text {
                if let calories = Double(calorieString) {
                    self.calorieEntryController.createEntry(calories: calories)
                    self.calorieEntryController.fetchCalorieEntries { (_) in
                        self.tableView.reloadData()
                    }
//                    navigationController?.popViewController(animated: true)
                } else {
                    print("Please enter a valid number")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.entries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
            as? CalorieTableViewCell else { return UITableViewCell() }
        let entries = calorieEntryController.entries
        let calories = entries[indexPath.row].calories
        let timestamp = entries[indexPath.row].timestamp
        cell.calories.text = "\(calories)"
        cell.timestamp.text = "\(timestamp ?? Date())"
        return cell
    }
}
