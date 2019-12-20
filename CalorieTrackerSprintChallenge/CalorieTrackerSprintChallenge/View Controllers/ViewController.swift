//
//  ViewController.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    var entryController = CalorieEntryController()
    let df = DateFormatter()
    var series: ChartSeries?
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var calorieEntryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .newEntry, object: nil)
    }
    
    @IBAction func addCalorieEntryTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Entry", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter Calorie Amount"
        }
        // TODO: - finish action after EntryController has been created
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let calorieAmount = alert.textFields?.first?.text,
                !calorieAmount.isEmpty else { return }
            let newEntry = CalorieEntryRep(amount: calorieAmount, timestamp: Date())
            self.entryController.createEntry(amount: calorieAmount, timestamp: Date())
            self.entryController.entriesArray.append(newEntry)
            self.updateViews()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc func updateViews() {
        calorieEntryTableView.reloadData()
        calorieChart.reloadInputViews()
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calorieEntryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        df.dateStyle = .medium
        df.timeStyle = .short
        
        cell.textLabel?.text = entryController.entriesArray[indexPath.row].amount
        cell.detailTextLabel?.text = df.string(from: entryController.entriesArray[indexPath.row].timestamp)
        
        return cell
    }
    
    
}
