//
//  CalorieChartTableViewController.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChartTableViewController: UITableViewController {
    
    // requires notification center to call a function to update the chart

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the chart empty instance? or just let it run blank for now bc first time thru there will be no chart so prefer viewWillAppear
        chart.add(series)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // not sure if chart stuff will need to be here, but probably bc this gets called before the viewLoads, and the chart might not show up if you don't put it here
        
    }
    
    @IBAction func AddCalorieDatapoint(_ sender: Any) {
        
        // show alert controller
        // grab user-entered calorie data
        
        let alertController = UIAlertController(title: "What's In Your Trough?", message: "Enter the calories inhaled today!", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: calorieTextField)
        
        let enterAction = UIAlertAction(title: "ENTER", style: .default, handler: self.enterHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(enterAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    
    }
    
    func calorieTextField(textField: UITextField!) {
        calorieTextField = textField
        calorieTextField?.placeholder = "Calories [no decimals]"
    }
    
    func enterHandler(alert: UIAlertAction!) {
        
        // Make sure User entered safe data, then add/append the entry to model, and save the model in CoreDataStack
        guard let calorie = Int16(calorieTextField!.text!) /*, !calorie.isEmpty*/ else {return}
        
        calorieEntry.calorie = calorie
        calorieEntryController.addUserEnteredData(calorieEntry: calorieEntry)

        // display in TableView (from calorie entries array)
        
        // concurrency: due to size of project, not necessarily needed, but if any task is cpu intense it would be pulling the calorie entries data from Core Data to display on the chart
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0 //calorieEntryController.calories().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configuration: Calories on left; timestamp on right
        
        cell.detailTextLabel?.text = "date" //calorieEntryController.timestamp[indexPath.row]
        cell.textLabel?.text = "7" //calorieEntryController.calories[indexPath.row]

        return cell
    }
    
    //MARK: Properties
    
    
    @IBOutlet weak var chart: Chart!
    
    var calories = [3, 1, 2]
    
    // loop thru calories, should be a tuple of calorie x and index y
    
    // let data = [
//    (x: 0, y: 0),
//    (x: 1, y: 3.1),
//    (x: 4, y: 2),
//    (x: 5, y: 4.2),
//    (x: 7, y: 5),
//    (x: 9, y: 9),
//    (x: 10, y: 8)
//    ]
    
    //let series = ChartSeries(data: data)
    
    let series = ChartSeries([3, 1, 3])
    
    var calorieEntry = CalorieEntry()
    
    var calorieTextField: UITextField?
    
    var calorieEntryController = CalorieEntryController()

}
