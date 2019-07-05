//
//  CalorieChartTableViewController.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit

class CalorieChartTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddCalorieDatapoint(_ sender: Any) {
        
        // show alert controller
        // grab user-entered calorie data
        // attach timestamp to calorie entry
        // display in TableView (from calorie entries array)
        // Save to Core Data
        // refresh chart with updated Core Data model
        
        // concurrency: due to size of project, not necessarily needed, but if any task is cpu intense it would be pulling the calorie entries data from Core Data to display on the chart
        
        
        
        
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configuration: Calories on left; timestamp on right

        return cell
    }


}
