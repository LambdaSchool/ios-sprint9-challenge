//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Nathanael Youngren on 3/15/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let chartVC = children.first as? ChartViewController else { fatalError("Chart View Controller is missing.") }
        chartViewController = chartVC
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = entryController.entries[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
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
            guard let caloriesText = calories.text, !caloriesText.isEmpty else { return }
            let caloriesNumber = Int(caloriesText)!
            self.entryController.createEntry(numberOfCalories: caloriesNumber)
            
            let nc = NotificationCenter.default
            nc.post(name: .newCalorieAmountAdded, object: self)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        addEntryAlert.addAction(submitAction)
        addEntryAlert.addAction(cancelAction)
        
        present(addEntryAlert, animated: true, completion: nil)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chartVC = segue.destination as? ChartViewController {
            let calories = entryController.entries.map { Double($0.amountOfCalories) }
            chartVC.calories = calories
        }
    }
    
    // MARK: - Properties
    
    let entryController = EntryController()
    private var chartViewController: ChartViewController?
}

extension NSNotification.Name {
    static let newCalorieAmountAdded = NSNotification.Name("newCalorieAmountAdded")
}
