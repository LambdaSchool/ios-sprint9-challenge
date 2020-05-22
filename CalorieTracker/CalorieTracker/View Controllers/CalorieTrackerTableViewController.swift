//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Chris Dobek on 5/22/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart


class CalorieTrackerTableViewController: UITableViewController {
    
    @IBOutlet private var chart: Chart!
    
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
    
    fileprivate var textField: UITextField?
    
    fileprivate lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "Add Calorie Intake.", message: "Enter the number of calories below.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { _ in
            print(self.textField?.text ?? "")
            self.saveCalorieIntake()
            self.textField?.text = ""
            self.saveCalorieIntake()
            NotificationCenter.default.post(name: .updateName, object: self)
        }
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        alert.addTextField { textField in
            self.textField = textField
        }
        return alert
    }()
    
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present(alertController, animated: true)
    }
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .updateName, object: nil)

        chart.add(calorieSeriesArray)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @objc func refresh() {
           chart.removeAllSeries()
           chart.add(calorieSeriesArray)
           tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieIntakeArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorieIntake = calorieIntakeArray[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorieIntake.dateEntered ?? Date())

        return cell
    }

}
