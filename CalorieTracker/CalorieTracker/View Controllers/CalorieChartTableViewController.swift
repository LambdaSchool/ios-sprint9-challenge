//
//  CalorieChartTableViewController.swift
//  CalorieTracker
//
//  Created by John Kouris on 12/14/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChartTableViewController: UITableViewController {
    
    @IBOutlet var chartView: Chart!
    var calorieLogs = [CalorieNote]()
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalorieLog), name: .calorieLogChanged, object: nil)
        
        container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Unresolved error loading the persistent stores \(error)")
            }
        }
        
        loadSavedData()
        plotGraph()
    }
    
    func plotGraph() {
        var calorieCountSeries = [Double]()
        
        for log in calorieLogs {
            calorieCountSeries.append(Double(log.calories)!)
        }
        
        let series = ChartSeries(calorieCountSeries)
        
        series.color = ChartColors.blueColor()
        series.area = true
        chartView.add(series)
    }
    
    @objc func updateCalorieLog() {
        tableView.reloadData()
        plotGraph()
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = CalorieNote.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            calorieLogs = try container.viewContext.fetch(request)
            print("Got \(calorieLogs.count) logs")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieLogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)

        cell.textLabel?.text = "Calories: \(calorieLogs[indexPath.row].calories)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.detailTextLabel?.text = "Date: \(formatter.string(from: calorieLogs[indexPath.row].date))"

        return cell
    }

    @IBAction func addTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your calories here"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textFieldEntry = alertController.textFields![0].text
            let calorieNote = CalorieNote(context: self.container.viewContext)
            
            self.configure(calorieNote: calorieNote, text: textFieldEntry!)
            
            self.calorieLogs.append(calorieNote)
            
            NotificationCenter.default.post(name: .calorieLogChanged, object: nil)
            
            self.saveContext()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configure(calorieNote: CalorieNote, text: String) {
        calorieNote.calories = text
        calorieNote.date = Date()
    }

}
