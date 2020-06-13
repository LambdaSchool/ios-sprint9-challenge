//
//  CaloriesViewController.swift
//  CalorieTracker
//
//  Created by Claudia Contreras on 6/12/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class CaloriesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - IBAction
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake",
                                                message: "Enter the amount of caloreis in the field",
                                                preferredStyle: .alert)
        
        var caloriesTextField: UITextField!
        
        alertController.addTextField { (textField) in
            caloriesTextField = textField
            textField.placeholder = "Calories:"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default)
        // Need to add Code to save the caloreisTextField data
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }

}

extension CaloriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)
        cell.textLabel?.text = "Calories:"
        cell.detailTextLabel?.text = "Date"
        
        return cell
    }
    
    
}
