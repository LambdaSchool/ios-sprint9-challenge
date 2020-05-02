//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var intakeTableView: UITableView!
    @IBOutlet weak var intakeGraphView: UIView!

    let calorieIntakeController = CalorieIntakeController()

    override func viewDidLoad() {
        super.viewDidLoad()

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
