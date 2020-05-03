//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Christy Hicks on 5/3/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var chart: Chart!
    
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
        let alertController = UIAlertController(title: "Add Calorie Intake.", message: "Enter the number of calories below.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            print(self.textField?.text ?? "")
            self.saveCalorieIntake()
            self.textField?.text = ""
            
            NotificationCenter.default.post(name: .updateViews, object: self)
        }))
        
        alertController.addTextField { textField in
            self.textField = textField
        }
        return alertController
    }()
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .short
       return formatter
    }()
    
    fileprivate var textField: UITextField?
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present(alertController, animated: true)
    }
    
    // MARK: - Method
    func saveCalorieIntake() {
        guard let calories = textField!.text, !calories.isEmpty else { return }
        
        let cals: Int = Int(calories) ?? 0
        _ = CalorieIntake(calories: cals, dateEntered: Date())
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChart), name: .updateViews, object: nil)
        
        chart.add(calorieSeriesArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func refreshChart() {
        chart.removeAllSeries()
        chart.add(calorieSeriesArray)
        tableView.reloadData()
    }

    // MARK: - Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
