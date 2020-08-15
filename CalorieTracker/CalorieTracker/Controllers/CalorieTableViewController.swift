//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/14/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

class CalorieTableViewController: UIViewController {
    
    let calorieController = CalorieController()
    let calorieCell = "CalorieCell"
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieController.calories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: calorieCell, for: indexPath)
        let calorie = calorieController.calories[indexPath.row]
        cell.textLabel?.text = "You had \(Int(calorie.recordedCalories))"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.timeRecorded!)
        return cell
    }
}

extension CalorieTableViewController: UITableViewDelegate {
    
}

extension CalorieTableViewController: UITableViewDataSource {
    
}
