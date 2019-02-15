//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    var calorieDataController: CalorieDataController!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer that will notify the table view when the data has been updated.
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .updatedCalorieDataNotification, object: nil)
        updateViews()
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieDataController.calorieDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorieData = calorieDataController.calorieDatas[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(Int(calorieData.calories))"
        cell.detailTextLabel?.text = calorieData.formattedTimestamp
        
        return cell
    }
    
    // MARK: - Utility Methods
    @objc private func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
