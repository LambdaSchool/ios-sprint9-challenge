//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Paul Yi on 3/15/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import UIKit
import SwiftChart

extension NSNotification.Name {
    static let didCreateCaloricIntake = NSNotification.Name("DidCreateCalorieIntake")
}

class CalorieIntakeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didCreateCalorieIntake(_:)), name: .didCreateCaloricIntake, object: nil)
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
                
                do {
                    try calorieIntake.managedObjectContext?.save()
                }
                catch {
                    NSLog("Failed to save to context.")
                }
                
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: .didCreateCaloricIntake, object: self)
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
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)
        
        
        
        return cell
    }
    
    @IBOutlet weak var chart: Chart!
    
}



