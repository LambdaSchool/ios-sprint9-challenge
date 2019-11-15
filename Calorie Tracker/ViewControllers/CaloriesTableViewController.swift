//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    
    //MARK: Properties
    var newCalorie = ""
    
    @IBOutlet weak var chartView: Chart!
    
    var series = ChartSeries([0, 6, 9, 4, 5, 6, 7, 8, 3, 5])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChart()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    @IBAction func addIntakeButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Calorie", message: "Enter New Calorie Amount", preferredStyle: .alert)
        
        let calorieAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            
            // Getting textfield's text
            let amountTxt = alert.textFields![0]
            self.newCalorie = amountTxt.text ?? ""
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ( action) -> Void in })
        
        alert.addTextField(configurationHandler: { (textField: UITextField) in
            textField.placeholder = "Enter Calorie"
            textField.keyboardType = .default
        })
        
        alert.addAction(calorieAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    
    
    func updateChart() {
        series.color = ChartColors.greenColor()
        chartView.add(series)
        
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


}
