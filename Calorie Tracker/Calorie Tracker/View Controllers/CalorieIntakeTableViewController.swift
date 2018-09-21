//
//  CalorieIntakeTableViewController.swift
//  Calorie Tracker
//
//  Created by Lisa Sampson on 9/21/18.
//  Copyright © 2018 Lisa M Sampson. All rights reserved.
//

import UIKit
import SwiftChart

extension NSNotification.Name {
    static let didCreateCalorieIntake = NSNotification.Name("DidCreateCalorieIntake")
}

class CalorieIntakeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didCreateCalorieIntake(_:)), name: .didCreateCalorieIntake, object: nil)
    }
    
    @IBAction func addCaloriesWasTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Calories: "
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            
            
            if let calories = alert.textFields?.first?.text {
                let calorieIntake = CalorieIntake(calorie: Int16(calories) ?? 0)
                self.calorieIntakes.append(calorieIntake)
                
                do {
                    try calorieIntake.managedObjectContext?.save()
                }
                catch {
                    NSLog("Failed to save to context.")
                }
                
                let nc = NotificationCenter.default
                nc.post(name: .didCreateCalorieIntake, object: self)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Notifications
    
    @objc func didCreateCalorieIntake(_ notification: Notification) {
        tableView?.reloadData()
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieIntakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)

        let calorieIntake = calorieIntakes[indexPath.row]
        cell.textLabel?.text  = "Calories: \(calorieIntake.calorie)"
        cell.detailTextLabel?.text = "\(calorieIntake.timestamp ?? Date())"

        return cell
    }
    
    @IBOutlet weak var chart: Chart!
    
    var calorieIntakes: [CalorieIntake] = []
}
