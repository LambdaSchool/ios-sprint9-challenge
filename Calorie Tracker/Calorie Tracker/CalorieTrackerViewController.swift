//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: Chart!
    let calorieEntryController = CalorieEntryController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews),
                                               name: .calorieEntriesUpdated, object: nil)
        updateViews()
    }
    @IBAction func addCalorieEntryButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Entry",
                                      message: "Please enter the number of calories in the text field",
                                      preferredStyle: .alert)
        alert.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Number of Calories"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let calorieString = alert.textFields![0].text, !calorieString.isEmpty else { return }
                if let calories = Double(calorieString) {
                    self.calorieEntryController.createEntry(calories: calories)
                    NotificationCenter.default.post(name: .calorieEntriesUpdated, object: nil)
                } else {
                    print("Please enter a valid number")
                }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
    @IBAction func deleteAllEntriesTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Everything?",
                                      message: """
                                        All entries will be deleted and your
                                        data will be permanently erased.
                                        This action is irreversible.
                                        """,
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete All Data", style: .destructive) { (_) in
            self.calorieEntryController.deleteAllEntries()
            self.chartView.removeAllSeries()
            NotificationCenter.default.post(name: .calorieEntriesUpdated, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    @objc func updateViews() {
        calorieEntryController.fetchCalorieEntries { (_) in
            tableView.reloadData()
            let entries = calorieEntryController.entries
            var entryCount: Double = 0
            var data: [(x: Double, y: Double)] = []
            for entry in entries {
                let xValue = entryCount
                let yValue = entry.calories
                data.append((xValue, yValue))
                entryCount += 1
            }
            let series = ChartSeries(data: data)
            series.color = ChartColors.cyanColor()
            series.area = true
            chartView.add(series)
        }
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        if let timestamp = timestamp {
            cell.calories.text = "Calories: \(calories)"
            cell.timestamp.text = dateFormatter.string(from: timestamp)
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let entry = calorieEntryController.entries[indexPath.row]
                calorieEntryController.deleteEntry(entry: entry)
                self.chartView.removeAllSeries()
                NotificationCenter.default.post(name: .calorieEntriesUpdated, object: nil)
        }
    }
}
