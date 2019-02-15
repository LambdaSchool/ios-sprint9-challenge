//
//  CalorieList.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit
import CoreData

class CalorieList: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    //Declaring the Calorie Chart
    let calorieChart = Chart(frame: CGRect(x: 0, y: 62, width: 375, height: 200))
    let series = CalorieManager.shared.buildChartData()
    let cmgr = CalorieManager.shared
    
    //Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        FirebaseManager.shared.getFromFB()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addSubview(calorieChart)
        calorieChart.add(series)
    }
    
    //Add Calories Button
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        //Show a popup alert
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of Calories in the field", preferredStyle: .alert)
        
        // Add a textfield to the alert to take the entry
        alert.addTextField { textField in
            textField.placeholder = "Number of Calories"
            textField.textAlignment = .center
        }
        
        // What happens when they click cancel
        let cancelEntry = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancelled")
        }
        
        // What happens when they click submit
        let submitEntry = UIAlertAction(title: "Submit", style: .default) { _ in
            
            guard let entry = Double((alert.textFields?.first?.text)!) else { return }
            
            let time = Date() //Grab the current date and time
            
            let tempCalorie = Calorie(amount: entry, date: time )
            
            self.cmgr.newEntry(amount: tempCalorie.amount, date: tempCalorie.date!) //Make a new entry
            
            self.tableView.reloadData()
            
            print("Submitted Entry")
        }
        
        // Add the actions to the alert
        alert.addAction(cancelEntry)
        alert.addAction(submitEntry)
        
        //Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    //Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmgr.calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fatCell", for: indexPath)
        
        cell.textLabel?.text = String(cmgr.calories[indexPath.row].amount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            cmgr.deleteEntry(entry: cmgr.calories[indexPath.row])
        }
    }
    
    //Fetch Results Controller Delegate Methods

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update: tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move: tableView.deleteRows(at: [indexPath!], with: .automatic)
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    
}
