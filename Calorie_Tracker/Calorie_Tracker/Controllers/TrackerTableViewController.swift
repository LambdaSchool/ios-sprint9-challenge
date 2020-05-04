//
//  TrackerTableViewController.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class TrackerTableViewController: UITableViewController {

    @IBOutlet weak var addEntryButton: UIBarButtonItem!
    
    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath)
            as? TrackerTableViewCell else { return UITableViewCell()}
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        return cell
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
     UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entryController.entries.remove(at: indexPath.row)
        } else if editingStyle == .insert {
           
        }    
    }
    // ACTION: - Methods
    @IBAction func addEntryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Entry",
                                      message: "Enter the amount of Calories",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        alert.addTextField { (calorieEntry) in
            calorieEntry.placeholder = "Enter Calorie Count"
        }
        alert.addAction(alertAction)
        alert.addAction(cancelAlertAction)
        self.present(alert,animated: true, completion: nil)
    }
    

}
