//
//  ChartTableViewController.swift
//  CalorieTrackerSprint
//
//  Created by Jorge Alvarez on 2/28/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class ChartTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var chart: Chart!
    
    var calorieIntakeArray: [CalorieIntake] {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching calorieIntakes: \(error)")
            return []
        }
    }
    
    var calorieSeriesArray: ChartSeries {
        var temp: [Double] = []
        for intake in calorieIntakeArray {
            temp.append(Double(intake.calories))
        }
        return ChartSeries(temp)
    }
    
    fileprivate lazy var alertController: UIAlertController = {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            print(self.tf?.text ?? "")
            
            self.saveCalorieIntake()
            // Clear textfield after 
            self.tf?.text = ""
            // ring bell
            NotificationCenter.default.post(name: .updateViews, object: self)
        }))
        
        ac.addTextField { (textField) in
            self.tf = textField
        }
        return ac
    }()
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .short
       return formatter
    }()
    
    fileprivate var tf: UITextField?
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present(alertController, animated: true)
    }
    
    func saveCalorieIntake() {
        guard let calories = tf!.text, !calories.isEmpty else {return}
        
        let cals: Int = Int(calories) ?? 0 // why does this need to be unwrapped again?
        let _ = CalorieIntake(calories: cals, dateEntered: Date())
        // Save
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChart), name: .updateViews, object: nil)
        
        chart.add(calorieSeriesArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /// Called when notification is heard
    @objc func refreshChart() {
        print("heard bell ring")
        chart.removeAllSeries()
        chart.add(calorieSeriesArray)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieIntakeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let calorieIntake = calorieIntakeArray[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorieIntake.dateEntered ?? Date())

        return cell
    }
}
