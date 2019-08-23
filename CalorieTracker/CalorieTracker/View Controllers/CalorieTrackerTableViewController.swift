//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Sean Acres on 8/23/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {

    let calorieController = CalorieController()
    
    @IBOutlet weak var calorieChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addCalories(_ sender: Any) {
        presentCalorieInput()
    }
    
    private func presentCalorieInput() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            if let amount = alert?.textFields![0].text {
                self.calorieController.createCaloriesEntry(amount: amount)
            }
        }))
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
