//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

// when the add button is tapped the user will enter in the amount of calories in an alert controller, the table view should display the amount of calories and the timestamp that it was entered

class CalorieTrackerTableViewController: UITableViewController {

    @IBOutlet weak var chartView: Chart!
    
    
    
//    let coreDataStack = CoreDataStack()
    
    var caloriesAdded: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let series = ChartSeries([1, 6, 2, 8, 4, 7, 3, 10, 8])
        series.color = ChartColors.greenColor()
        chartView.add(series)
    }

    @IBAction func addCalorieButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        let submitCaloriesAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let caloriesToSubmit = textField.text else {
                    return
            }
            
            self.save(calories: caloriesToSubmit)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        
        alert.addAction(submitCaloriesAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func save(calories: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let enity = NSEntityDescription.entity(forEntityName: "CalorieTracker", in: managedContext)!
        let newCalories = NSManagedObject(entity: enity, insertInto: managedContext)
        newCalories.setValue(calories, forKey: "calories")

        do {
            try managedContext.save()
            caloriesAdded.append(newCalories)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caloriesAdded.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
//        let calories = caloriesAdded[indexPath.row]
//        cell.textLabel?.text = calories.value(forKeyPath: "calories") as? String
//        cell.detailTextLabel?.text = calories.value(forKeyPath: "timestamp") as? String
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

}
