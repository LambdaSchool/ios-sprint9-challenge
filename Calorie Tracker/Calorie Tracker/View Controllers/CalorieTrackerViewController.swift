//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Wyatt Harrell on 4/24/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextfield: UITextField!
        
        alert.addTextField { (textField) in
            calorieTextfield = textField
            textField.placeholder = "Calories:"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            // Add Calorie Intake to Core Data Here
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    

}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        cell.textLabel?.text = "Hello"
        cell.detailTextLabel?.text = "Test"

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
}
