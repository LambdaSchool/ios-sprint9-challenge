//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {

    // MARK: - Properties
    let calorieDataController = CalorieDataController()
    
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.backgroundColor = .white
    }

    // MARK: - Actions
    @IBAction func addCalorieData(_ sender: Any) {
        presentAddCalorieAlert()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalorieTrackerTableViewController {
            destinationVC.calorieDataController = calorieDataController
        }
    }
    
    // MARK: - Utility Methods
    private func presentAddCalorieAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories"
            
            calorieTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            if let calorieString = calorieTextField?.text, let calories = Double(calorieString) {
                self.calorieDataController.createCalorieData(calories: calories)
                self.calorieDataController.fetchData()
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
}

extension Notification.Name {
    static let updatedCalorieDataNotification = Notification.Name("UpdatedCalorieDataNotification")
}
