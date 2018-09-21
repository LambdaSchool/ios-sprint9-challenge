//
//  CaloriesTableViewController.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class CaloriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addCalories(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the amount of calories",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Calories"
        })

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text {
                print("Your calories: \(calories)")
            }
        }))

        self.present(alert, animated: true)
    }

}
