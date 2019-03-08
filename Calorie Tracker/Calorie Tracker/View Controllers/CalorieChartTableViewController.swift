//
//  CalorieChartTableViewController.swift
//  Calorie Tracker
//
//  Created by Moses Robinson on 3/8/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieChartTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addCalorieIntakeButtonTapped(_ sender: Any) {
        
        
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 0
    }

    let reuseIdentifier = "CalorieIntakeCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    // MARK: - Properties
    
    @IBOutlet var calorieChart: Chart!
}
