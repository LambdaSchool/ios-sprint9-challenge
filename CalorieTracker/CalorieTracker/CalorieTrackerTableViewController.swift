//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Sean Hendrix on 1/11/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    var calorieDataController: CalorieDataController!
    var people: [Person] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer that will notify the table view when the data has been updated.
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .updatedCalorieDataNotification, object: nil)
        updateViews()
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return people[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieDataController.fetchCalories(for: people[section]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorieData = calorieDataController.fetchCalories(for: people[indexPath.section])[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(Int(calorieData.calories))"
        cell.detailTextLabel?.text = calorieData.formattedTimestamp
        
        return cell
    }
    
    // MARK: - Utility Methods
    @objc private func updateViews() {
        DispatchQueue.main.async {
            self.people = self.calorieDataController.fetchPeople()
            self.tableView.reloadData()
        }
    }
    
}
