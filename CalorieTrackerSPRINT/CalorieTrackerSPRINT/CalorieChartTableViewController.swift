//
//  CalorieChartTableViewController.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieChartTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // not sure if chart stuff will need to be here, but probably bc this gets called before the viewLoads, and the chart might not show up if you don't put it here
        
        
        chart.add(series)
        
    }
    
    @IBAction func AddCalorieDatapoint(_ sender: Any) {
        
        // show alert controller
        
        let alertController = UIAlertController(title: <#T##String?#>, message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
        
        // grab user-entered calorie data
        // attach timestamp to calorie entry
        // display in TableView (from calorie entries array)
        // Save to Core Data
        // refresh chart with updated Core Data model
        
        // concurrency: due to size of project, not necessarily needed, but if any task is cpu intense it would be pulling the calorie entries data from Core Data to display on the chart
        
        
        
        
        
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configuration: Calories on left; timestamp on right

        return cell
    }
    
    //MARK: Properties
    
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    var calorieEntry = CalorieEntry()
    var calories: [calorieEntry.calorie] = []
    let series = ChartSeries(calories)
    
    


}
