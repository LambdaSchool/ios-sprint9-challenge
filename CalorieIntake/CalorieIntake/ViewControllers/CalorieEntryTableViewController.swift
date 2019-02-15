//
//  CalorieEntryTableViewController.swift
//  CalorieIntake
//
//  Created by Benjamin Hakes on 2/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieEntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up
        
        let headerView: Chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        series.area = true
        headerView.add(series)
        tableView.tableHeaderView = headerView
        
        

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

        // Configure the cell...

        return cell
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    @IBAction func addNewCalories(_ sender: Any) {
        let alert = DisplayEntryAlertWindow.getAlterDisplay()
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Properties
    @IBOutlet weak var addCaloriesBarButton: UIBarButtonItem!
    
}
