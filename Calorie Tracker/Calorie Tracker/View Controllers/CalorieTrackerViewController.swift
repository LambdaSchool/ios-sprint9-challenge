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

        // Do any additional setup after loading the view.
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
