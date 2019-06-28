//
//  CalorieTableViewController.swift
//  CalorieSprint
//
//  Created by Ryan Murphy on 6/28/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit

class CalorieTableViewController: UITableViewController {
    
    
    
    let entryController = EntryController()
    private var chartViewController: ChartViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let chartVC = children.first as? ChartViewController else { fatalError("ChartVC Not Loading") }
        chartViewController = chartVC
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = entryController.entries[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = "MMM d, yyyy 'at' hh:mm a"
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
        let date = dateFormatter.string(from: entry.timestamp!)
        
        cell.textLabel?.text = "Calories: \(entry.numberOfCalories)  \(date)"
        
        return cell
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var calories: UITextField!
        
        let addEntryAlert = UIAlertController(title: "Add Caloie Intake", message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        
        addEntryAlert.addTextField { (textField) in
            textField.placeholder = "Calories:"
            calories = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let caloriesText = calories.text, !caloriesText.isEmpty else { return }
            let caloriesNumber = Int(caloriesText)!
            self.entryController.createEntry(numberOfCalories: caloriesNumber)
            
            let nc = NotificationCenter.default
            nc.post(name: .calorieAmountAdded, object: self)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        addEntryAlert.addAction(submitAction)
        addEntryAlert.addAction(cancelAction)
        
        present(addEntryAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chartVC = segue.destination as? ChartViewController {
            let calories = entryController.entries.map { Double($0.numberOfCalories) }
            chartVC.calories = calories
        }
    }
    

}

extension NSNotification.Name {
    static let calorieAmountAdded = NSNotification.Name("calorieAmountAdded")
}
