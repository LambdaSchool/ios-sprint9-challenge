//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Scott Bennett on 10/26/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController, ChartDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properites
    
    var entries: [NSManagedObject] = [] {
        didSet {
            updateView()
        }
    }
    var caloriesArray: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entry")
        
        do {
            entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Cound not fetch. \(error), \(error.userInfo)")
        }
        
        //Look for a better way to do this
        for entry in entries {
            let arrayEntry = (entry.value(forKey: "calories") as! NSString).doubleValue
            caloriesArray.append(arrayEntry)
        }
    }
    
    //Add calories using an alert controller
    @IBAction func addCalorie(_ sender: Any) {
        
        //Setup alert controller
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter your calories", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Submit", style: .default) { [unowned self] action in
            guard let entry = alertController.textFields?[0].text else { return }
            if entry != "" {
                let date = self.formatter.string(from: Date())
                self.save(calories: entry, timestamp: date)
                self.caloriesArray.append(Double(entry) ?? 0.0)
            }
        }
        
        //Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        //Add textfields
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        //Add actions
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        //Presenting alert
        self.present(alertController, animated: true, completion: nil)        
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {

    }

    func didFinishTouchingChart(_ chart: Chart) {

    }

    func didEndTouchingChart(_ chart: Chart) {

    }
    
    func save(calories: String, timestamp: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        entry.setValue(calories, forKey: "calories")
        entry.setValue(timestamp, forKey: "timestamp")
        
        do {
            try managedContext.save()
            entries.append(entry)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // MARK: - TableView Data Sourse and Delegte
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.value(forKeyPath: "calories") as? String
        cell.detailTextLabel?.text = entry.value(forKeyPath: "timestamp") as? String
        return cell
    }
    
    // MARK: - Private Functions
    
    private func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.chart.removeAllSeries()
            let series = ChartSeries(self.caloriesArray)
            series.color = .red
            series.area = true
            self.chart.add(series)
        }
    }
    
    // Date formatter
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

