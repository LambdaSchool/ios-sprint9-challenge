//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    // MARK: - Properties
    var calorieTrackerController = CalorieTrackerController()
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: .addCalorieEntry, object: nil)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieTrackerController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as! CalorieTableViewCell
        cell.calorieLabel.text = "Calories: \(Int(calorieTrackerController.entries[indexPath.row].calorie))"
        cell.dateLabel.text = "\((calorieTrackerController.entries[indexPath.row].timestamp)!)"
        return cell
    }
    
    @objc func updateViews(_ notification: Notification) {
        print("I'm the observer in the CalorieTrackerTableViewController.")
        print("I heard somebody tapped the submit button in the GraphViewController.")
        print("I'm gonna reload the my tableView...(I'm definitely going overboard)")
        calorieTrackerController = CalorieTrackerController()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
