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
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    
    var coreDataStack: CoreDataStack?
    
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
            
            do {
                try self.coreDataStack?.save()
                //            (calories: caloriesToSubmit)
                            self.tableView.reloadData()
            } catch {
                
            }
            
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
        
        let calories = caloriesAdded[indexPath.row]
        cell.textLabel?.text = calories.value(forKeyPath: "calories") as? String
//        cell.detailTextLabel?.text = dateFormatter.value(forKey: "timestamp") as? String
        return cell
    }
}
