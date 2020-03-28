//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var entryTableView: UITableView!

    private var entryController = CalorieEntryController()
    private var tableDataSource = CalorieEntryTableViewDataSource()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        entryTableView.delegate = self
        entryTableView.dataSource = tableDataSource

        tableDataSource.entryTableView = entryTableView
        tableDataSource.entryController = entryController

        entryController.delegate = tableDataSource

        dataDidUpdate()
        entryTableView.reloadData()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataDidUpdate),
            name: .dataDidUpdate,
            object: nil)
    }

    @IBAction func addEntryButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Add calorie intake",
            message: "Enter the amount of calories in the field.",
            preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "# of calories"
        }

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "Add entry",
            style: .default,
            handler: { [unowned alert] _ in
                guard
                    let caloriesText = alert.textFields?[0].text,
                    let calories = Int(caloriesText)
                    else { return }
                do {
                    try self.entryController.createEntry(withCalories: calories)
                    NotificationCenter.default.post(name: .dataDidUpdate, object: nil)
                } catch {
                    NSLog("Error saving entry to persistent store: \(error)")
                }
        }))

        present(alert, animated: true, completion: nil)
    }

    @objc
    func dataDidUpdate() {
        calorieChart.removeAllSeries()
        var data = [Double]()
        if let entries = entryController.entries {
            data = entries.map { Double($0.calories) }.reversed()
        }
        calorieChart.add(ChartSeries(data))
        calorieChart.series[0].area = true

        entryTableView.reloadData()
    }
}

// MARK: - Table View Delegate

extension CalorieTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
