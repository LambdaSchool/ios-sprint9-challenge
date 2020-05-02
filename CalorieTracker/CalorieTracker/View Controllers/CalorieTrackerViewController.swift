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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: IBActions
    @IBAction func addNewIntakeButton(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Add the amount of calories in the field",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
        }

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
