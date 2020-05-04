//
//  TrackerTableViewController.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class TrackerTableViewController: UITableViewController {

    @IBOutlet weak var addEntryButton: UIBarButtonItem!
    @IBOutlet weak var calorieChart: Chart!
    let entryController = EntryController()
    var entries = [Entry]()
    let chart = Chart()
    var data: [Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath)
            as? TrackerTableViewCell else { return UITableViewCell()}
        let entry = entries[indexPath.row]
        cell.entry = entry
        return cell
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
     UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entries.remove(at: indexPath.row)
        } else if editingStyle == .insert {
    }
    }
    // ACTION: - Methods
    @IBAction func addEntryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Entry",
                                      message: "Enter the amount of Calories",
                                      preferredStyle: .alert)
        alert.addTextField { (calorieEntry) in
        calorieEntry.placeholder = "Enter Calorie Count"
        calorieEntry.textAlignment = .center
        calorieEntry.keyboardType = .numberPad
        guard let text = calorieEntry.text else { return }
        }
        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let text = alert.textFields?.first?.text
            self.addEntryToChart(entry: NSString(string: text ?? "null"))
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alert.addAction(alertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert,animated: true, completion: nil)
    }

    func addEntryToChart(entry: NSString) {
        let number = entry.doubleValue
        let currentDateTime = Date()
        let newEntry = Entry(calories: number, date: currentDateTime)
        self.entries.append(newEntry)
        entryController.save()
        data.append(number)
        let series = ChartSeries(data)
        calorieChart.add(series)
    }

}
