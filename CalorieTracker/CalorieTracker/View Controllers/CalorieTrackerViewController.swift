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

    @IBOutlet private weak var calorieChartView: Chart!
    @IBOutlet private weak var entryTableView: UITableView!

    private lazy var calorieEntryController = CalorieEntryController()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        calorieEntryController.delegate = self
        setUpChart()
        entryTableView.reloadData()
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
                    let calories = Double(caloriesText)
                    else { return }

                _ = CalorieEntry(calories: calories)

                do {
                    try self.calorieEntryController.saveToPersistentStore()
                } catch {
                    NSLog("Error saving entry to persistent store: \(error)")
                }
        }))

        present(alert, animated: true, completion: nil)
    }

    func setUpChart() {
        var data = [Double]()
        if let entries = calorieEntryController.fetchedResultsController.fetchedObjects {
            data = entries.map { $0.calories }
        }
        calorieChartView.add(ChartSeries(data))
    }
}
