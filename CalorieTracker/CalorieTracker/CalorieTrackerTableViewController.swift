//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Nathanael Youngren on 3/15/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = entryController.entries[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let date = dateFormatter.string(from: entry.timestamp!)
        
        cell.textLabel?.text = "Calories: \(entry.amountOfCalories)     \(date)"
        
        return cell
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var calories: UITextField!
        
        let addEntryAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        
        addEntryAlert.addTextField { (textField) in
            textField.placeholder = "Calories:"
            calories = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let caloriesText = calories.text else { return }
            let caloriesNumber = Int16(caloriesText)!
            self.entryController.createEntry(numberOfCalories: caloriesNumber)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        addEntryAlert.addAction(submitAction)
        addEntryAlert.addAction(cancelAction)
        
        present(addEntryAlert, animated: true, completion: nil)
    }
    
    
    let entryController = EntryController()
}
