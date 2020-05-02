//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Vuk Radosavljevic on 9/21/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData


extension NSNotification.Name {
    static let addCalories = NSNotification.Name("AddCalories")
}

class ViewController: UIViewController {

    var caloriesArrayForChart = [Double]()
   
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        
        do {
            calorieController.caloriesArray = try moc.fetch(fetchRequest)
            for calorie in calorieController.caloriesArray {
                if !caloriesArrayForChart.contains(Double(calorie.calories)) {
                    caloriesArrayForChart.append(Double(calorie.calories))
                }
            }
            let series = ChartSeries(caloriesArrayForChart)
            chart.add(series)
        } catch {
            print("Error fetching data")
        }
        
        
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateTableView), name: .addCalories, object: nil)
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
        
        for calorie in calorieController.caloriesArray {
            if !caloriesArrayForChart.contains(Double(calorie.calories)) {
                caloriesArrayForChart.append(Double(calorie.calories))
            }
        }
        let series = ChartSeries(caloriesArrayForChart)
        chart.add(series)
    }
    
    
    @IBAction func addCalorie(_ sender: Any) {
        let alert = UIAlertController(title: "Add your calories", message: nil, preferredStyle: .alert)
        var calorieTextField: UITextField?
        alert.addTextField { (textField) in
            textField.placeholder = "Calories"
            calorieTextField = textField
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calories = Calorie(calories: Int16((calorieTextField?.text)!) ?? 0)
            self.calorieController.create(calories: calories.calories)
            let nc = NotificationCenter.default
            nc.post(name: .addCalories, object: self)
        }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    let calorieController = CalorieController()
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.caloriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = calorieController.caloriesArray[indexPath.row]
        cell.textLabel?.text = String(calorie.calories)
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: calorie.timestamp!)
        
        cell.detailTextLabel?.text = now
        
        return cell
    }
    
    
}
