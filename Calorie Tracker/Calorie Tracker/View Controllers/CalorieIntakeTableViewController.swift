//
//  CalorieIntakeTableViewController.swift
//  Calorie Tracker
//
//  Created by Lisa Sampson on 9/21/18.
//  Copyright © 2018 Lisa M Sampson. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

extension NSNotification.Name {
    static let didCreateCalorieIntake = NSNotification.Name("DidCreateCalorieIntake")
}

class CalorieIntakeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didCreateCalorieIntake(_:)), name: .didCreateCalorieIntake, object: nil)
        
        calorieIntakes = fetchCalorieIntakeFromStore(context: CoreDataStack.shared.mainContext)
        
        for intake in calorieIntakes {
            let index = series.data.count
            let data = intake.calorie
            series.data.append((x: Double(index), y: Double(data)))
        }
        
        chart.add(series)
        series.color = ChartColors.greenColor()
        series.area = true
    }
    
    // MARK: - Persistent Store
    
    func fetchCalorieIntakeFromStore(context: NSManagedObjectContext) -> [CalorieIntake] {
        
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        }
        catch {
            NSLog("Error fetching calorie intakes: \(error)")
            return []
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addCaloriesWasTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Calories: "
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            
            
            if let calories = alert.textFields?.first?.text {
                let calorieIntake = CalorieIntake(calorie: Int16(calories) ?? 0)
                self.calorieIntakes.append(calorieIntake)
                
                let data = calorieIntake.calorie
                let index = self.series.data.count
                self.series.data.append((x: Double(index), y: Double(data)))
                
                do {
                    try calorieIntake.managedObjectContext?.save()
                }
                catch {
                    NSLog("Failed to save to context.")
                }
                
                let nc = NotificationCenter.default
                nc.post(name: .didCreateCalorieIntake, object: self)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Notifications
    
    @objc func didCreateCalorieIntake(_ notification: Notification) {
        tableView?.reloadData()
        chart.removeAllSeries()
        chart.add(series)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieIntakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)

        let calorieIntake = calorieIntakes[indexPath.row]
        cell.textLabel?.text  = "Calories: \(calorieIntake.calorie)"
        
        formatter.dateFormat = "MM/dd/yyyy 'at' hh:mm aaa"
        cell.detailTextLabel?.text = calorieIntake.timestamp.map({ (timestamp) -> String in
            return formatter.string(from: timestamp)
        })

        return cell
    }
    
    // MARK: - Properies and Outlets
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var chart: Chart!
    
    var calorieIntakes: [CalorieIntake] = []
    let series = ChartSeries([])
}
