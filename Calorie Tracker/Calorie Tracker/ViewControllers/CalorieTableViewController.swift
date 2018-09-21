//
//  CalorieTableViewController.swift
//  Calorie Tracker
//
//  Created by Jonathan T. Miles on 9/21/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import UIKit

class CalorieTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.calorieCounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorieCount = calorieController.calorieCounts[indexPath.row]
        guard let date = calorieCount.date else { return cell }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        cell.textLabel?.text = "Calories: \(calorieCount.calories)"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: date))"
        return cell
    }
    
    // MARK: - Buttons

    @IBAction func addCalorieCount(_ sender: Any) {
        configureAlert()
        
    }
    
    // MARK: - Properties
    
    let alert = UIAlertController(title: "Add Calorie Input", message: "Add the amount of calories in the field", preferredStyle: .alert)
    
    func configureAlert() {
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let caloriesString = self.alert.textFields?.first?.text {
                guard let calories = Int64(caloriesString) else { return }
                self.calorieController.createCalorieCount(with: calories)
            }
        }))
        self.present(alert, animated: true)
        tableView.reloadData() // may need to be moved elsewhere to refresh at the correct time
    }
    
    let calorieController = CalorieController()

}
