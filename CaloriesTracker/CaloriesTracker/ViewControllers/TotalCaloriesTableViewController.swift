//
//  TotalCaloriesTableViewController.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import SwiftChart

class TotalCaloriesTableViewController: UITableViewController {
    
    
    var caloriesController = CaloriesController()
    
    @IBOutlet private weak var caloriesChart: Chart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews(_:)), name: .whenUpdateGraph, object: nil)
        
       updateViews()
    }
    
    @objc func reloadViews(_ notification: Notification) {
        if notification.name == .whenUpdateGraph {
            updateViews()
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //        alert controller with textfield
        
        let alert = UIAlertController(title: "Add Calories Intake", message: "Fill the amount of the calories in the textfield", preferredStyle: .alert)
        
        var caloriesTextField: UITextField!
        alert.addTextField { (textField) in
            textField.placeholder = "Amount of Calories"
            caloriesTextField = textField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            //        Converting stirng calories in integer.
            let stringCalorieCount = caloriesTextField.text ?? ""
            let caloriesInt = Int(stringCalorieCount)
            if let caloriesInt = caloriesInt {
                self.caloriesController.createCalories(calories: caloriesInt, timestamp: Date())
            } else {
                print("Not a calorie")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
       
    }
    
    
    func updateViews() {
        
        caloriesChart.removeAllSeries()
        
        let series = ChartSeries(caloriesController.calories.map({ Double($0.calories)}))
        
        series.area = true
        series.colors = (
            above: ChartColors.greenColor(),
            below: ChartColors.yellowColor(),
            zeroLevel: 0
        )
        caloriesChart.add(series)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caloriesController.calories.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath) as! CaloriesTableViewCell
     
     // Configure the cell...
        cell.calories = caloriesController.calories[indexPath.row]
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
