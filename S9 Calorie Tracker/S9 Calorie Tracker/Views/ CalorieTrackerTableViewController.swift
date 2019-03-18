//
//  CalorieTrackerTableViewController.swift
//  S9 Calorie Tracker
//
//  Created by Angel Buenrostro on 3/17/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let calorieController = CaloriesController()
    var series = ChartSeries([])

    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieController.calories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)
        let caloriesResult = calorieController.calories[indexPath.row]
        cell.detailTextLabel?.text = caloriesResult.timeStamp?.asString(style: .medium)
        guard let calories = caloriesResult.calorieAmount else { fatalError() }
        cell.textLabel!.text = "Calories: \(String(describing: calories))"
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Functions
    
    func setUpChart(){
        calorieChart.backgroundColor = ChartColors.greyColor()
        var xLabels: [Double] = []
        var count = 1.0
        for _ in calorieController.calories{
            xLabels.append(count)
            count += 1
        }
        calorieChart.xLabels = xLabels
    }
    
    func update(){
        calorieChart.removeAllSeries()
//        for calories in calorieController.calories {
//            guard let amount = calories.calorieAmount else { return }
//            series.data.append((x: 1.0, y: Double(amount) ?? 0))
//        }
        var doubleCalories: [Double] = []
        for calories in calorieController.calories {
            guard let amount = calories.calorieAmount else { return }
            doubleCalories.append(Double(amount)!)
        }
        series = ChartSeries(doubleCalories)
        series.color = ChartColors.blueColor()
        calorieChart.add(series)
        
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        // Create alert to have user enter calorie information
        let calorieAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below", preferredStyle: .alert)
        
        calorieAlert.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
        }
        
        calorieAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        calorieAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            
            // ADD CALORIES TO THE CHART
            guard let text = calorieAlert.textFields![0].text else { return }
            let newCalories = Calories(calorieAmount: text)
            print(self.calorieController.calories.count)
            self.calorieController.calories.insert(newCalories, at: self.calorieController.calories.count)
            self.calorieController.saveToPersistentStore()
            self.update()
        }))
        present(calorieAlert, animated: true)
    }
    
    @IBOutlet weak var calorieChart: Chart!
}


extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm:ss a"
        return dateFormatter.string(from: self)
    }
}
