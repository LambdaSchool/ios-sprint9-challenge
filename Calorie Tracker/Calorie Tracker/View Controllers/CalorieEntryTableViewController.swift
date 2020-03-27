//
//  CalorieEntryTableViewController.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class CalorieEntryTableViewController: UITableViewController {
    
    // MARK: - Properties:
    
    var calorieController: CalorieController?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupCell(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let calorieController = calorieController,
            let date = calorieController.calorieEntries[indexPath.row].date else { return }
        let entry = calorieController.calorieEntries[indexPath.row]
        
        let calorieCount = Int(entry.count)
        
        let titleString = "\(calorieCount) calories"
        let dateString = Date.getFormattedDate(date: date)
        
        cell.textLabel?.text = titleString
        cell.detailTextLabel?.text = dateString
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController?.calorieEntries.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        setupCell(for: cell, at: indexPath)
        
        return cell
    }
    
}

