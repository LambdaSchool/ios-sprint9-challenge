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
    }
//    func viewWillAppear() {
//        super.viewWillAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: .addCalorieEntry, object: nil)
//    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieTrackerController.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        // I should make a type alias or something...
        cell.textLabel?.text = "Calories: \(Int(calorieTrackerController.entries[indexPath.row].calorie)) \t\((calorieTrackerController.entries[indexPath.row].timestamp)!)"
        return cell
    }
    
    @objc func updateViews(_ notification: Notification) {
        print ("I heard your notification")
        calorieTrackerController = CalorieTrackerController()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
