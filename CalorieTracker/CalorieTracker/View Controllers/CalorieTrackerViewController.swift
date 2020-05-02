//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet private weak var intakeTableView: UITableView!
    @IBOutlet private weak var intakeChartView: Chart!

    let series = ChartSeries([0, 600, 200, 800, 400, 700, 300, 1000, 800])

    let calorieIntakeController = CalorieIntakeController()

    override func viewDidLoad() {
        super.viewDidLoad()
        intakeTableView.delegate = self
        intakeTableView.dataSource = self
        intakeTableView.reloadData()

        series.color = ChartColors.greenColor()
        series.area = true
        intakeChartView.minY = 0
        intakeChartView.maxY = 1000
        intakeChartView.add(series)
    }

    // MARK: UITableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieIntakeController.listOfIntakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = intakeTableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell",
                                                             for: indexPath) as? CalorieIntakeTableViewCell
            else { return UITableViewCell() }

        return cell
    }

    // MARK: IBActions
    @IBAction func addNewIntakeButton(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Add the amount of calories in the field",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField { textField in
            textField.placeholder = "Calories:"
        }
        //swiftlint:disable:next unused_closure_parameter
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            if let caloriesText = alert.textFields?.first?.text, let calories = Int16(caloriesText) {
                self.calorieIntakeController.createIntake(withCalories: calories)
            }
        }))

        self.present(alert, animated: true)
    }
}
