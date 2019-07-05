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
        // grab user-entered calorie data
        
        let alertController = UIAlertController(title: "What's In Your Trough?", message: "Enter the calories inhaled today!", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: calorieTextField)
        
        let enterAction = UIAlertAction(title: "ENTER", style: .default, handler: self.enterHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
    }
    
    func calorieTextField(textField: UITextField!) {
        calorieTextField = textField
        calorieTextField?.placeholder = "Calories [no decimals]"
    }
    
    func enterHandler(alert: UIAlertAction!) {
        
        // Make sure User entered safe data, then add/append the entry to model, and save the model in CoreDataStack
        guard let calorie = calorieTextField?.text, !calorie.isEmpty else {return}
        
        calorieEntryController.addUserEnteredData(calorieEntry: calorieEntry)

        
        // Save to Core Data
        // this saves our data, but should i call calorieEntryController instead of doing it here?
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        // display in TableView (from calorie entries array)
        
        // concurrency: due to size of project, not necessarily needed, but if any task is cpu intense it would be pulling the calorie entries data from Core Data to display on the chart
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CalorieEntryController.calories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configuration: Calories on left; timestamp on right
        cell.detailTextLabel?.text = calorieEntryController.timestamp[indexPath.row]
        cell.textLabel?.text = calorieEntryController.calories[indexPath.row]

        return cell
    }
    
    //MARK: Properties
    
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    var calorieEntry = CalorieEntry()
    var calories: [CalorieEntry] = []
    let series = ChartSeries(calories)
    
    var calorieTextField: UITextField?
    
    var calorieEntryController = CalorieEntryController()


}
