//
//  CalorieChartTableViewController.swift
//  Calorie Tracker
//
//  Created by Juan M Mariscal on 6/12/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieChartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var calorieTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calorieTableView.delegate = self
        calorieTableView.dataSource = self
        calorieTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        calorieTableView.reloadData()
    }
    
    var calorieList: [Calorie] = []
    
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
    

    // MARK: - Table view data source



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieInputCell", for: indexPath) as? CalorieChartTableViewCell else {
            fatalError("Can't dequeue cell of type 'CalorieInputCell' ")
        }
        
        cell.calorieLabel.text = calorieList[indexPath.row].calorie
        cell.dateLabel.text = calorieList[indexPath.row].date.toString(dateFormat: "MM/dd/yy, h:mm a")
        
        // Configure the cell...

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieList.count
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func addCalorieButtonPressed(_ sender: Any) {
        promptForCalorieInput()
        calorieTableView.reloadData()
    }
    
    func promptForCalorieInput() {
        let ac = UIAlertController(title: "Enter Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        ac.addTextField()
        
        let sumbitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something with answer
            let calorieInput = Calorie(calorie: answer.text!, date: Date())
            self.calorieList.append(calorieInput)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            
        }
        
        ac.addAction(cancel)
        ac.addAction(sumbitAction)
        present(ac, animated: true)
    }
    
    
    
    // MARK: - Navigation



}
