//
//  CalorieTVC.swift
//  sprint9-calorieTracker
//
//  Created by Nikita Thomas on 1/11/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTVC: UITableViewController {

    @IBOutlet weak var chart: Chart!
    
    var calorieEntries: [CalorieEntry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieEntries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)
        
        let entry = calorieEntries[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(entry.calories)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: entry.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }

}
