//
//  CalorieChartViewController.swift
//  Calorie Tracker ST
//
//  Created by Jake Connerly on 10/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieChartViewController: UIViewController {

    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: Chart!

    let entryController = EntryController()

    var dateFormatter: DateFormatter {
        let formatter        = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone   = TimeZone(secondsFromGMT: 0)
        return formatter
    }

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        setUpChart()
    }

    // MARK: - IBActions & Methods

    func setUpChart() {
        var doubleEntries: [Double] = []

        for entry in entryController.entries {
            let double = Double(entry.calories)
            doubleEntries.append(double)
        }

        let series   = ChartSeries(doubleEntries)
        series.color = ChartColors.darkGreenColor()
        series.area  = true
        chartView.add(series)

        observeEntriesUpdate()
    }

    func observeEntriesUpdate() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: .entriesUpdated, object: nil)
    }

    @objc func refreshViews() {
        tableView.reloadData()
    }

    @IBAction func addEntryTapped(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)

        alert.addTextField { (setTextField) in
            setTextField.placeholder = "Enter Calories"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let calories = alert.textFields?[0].text,
                  let calorieInt = Int(calories) else { return }

            self.entryController.createEntry(calorieCount: calorieInt)
            self.setUpChart()
        }

        alert.addAction(cancel)
        alert.addAction(submit)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension CalorieChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = entryController.entries[indexPath.row]

        cell.textLabel?.text = "Calories: \(entry.calories)"
        if let date = entry.dateEntered {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        return cell
    }
}
