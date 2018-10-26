//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    var calorieDataController: CalorieDataController!
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
