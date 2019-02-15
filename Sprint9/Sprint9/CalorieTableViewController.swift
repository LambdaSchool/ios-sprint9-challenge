//
//  CalorieTableViewController.swift
//  Sprint9
//
//  Created by Sergey Osipyan on 2/15/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

extension NSNotification.Name {
    static let cleanCalories = NSNotification.Name("cleanCalories")
}

class CalorieTableViewController: UITableViewController {
    
    var calories: [Calorie] = []
    
    func fetchCalorieFromStore() -> [Calorie] {
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        
        let resualt = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        return resualt
    }
    
   
    var timestamp: [String] = []
    var series = ChartSeries([])
    
    
    @IBAction func addCalorie(_ sender: Any) {
        addCalories()
        
    }
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(cleanCalories(_:)), name: .cleanCalories, object: nil)
        calories = fetchCalorieFromStore()
        navigationItem.title = "Calorie Tracker"
        chart.frame = CGRect(x: 0, y: 0, width: 50, height: 450)
        let series = ChartSeries([0])
        series.area = true
        chart.xLabels = [0]
        chart.xLabelsFormatter = { "Day \(Int (round($1)))" }
        
        chart.add(series)
        
    }

    // MARK: - Table view data source
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Calorie", for: indexPath) as? CalorieTableViewCell else { fatalError("No such cell")}
      
        cell.calorie.text = "Calorie: \(calories[indexPath.row].data)" //" \(Int(data[indexPath.row]))"
        cell.timestamp.text = calories[indexPath.row].timestamp  //"\(timeFormatted)"
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            let calorie = data[indexPath.row]
//            
//            CoreDataStack.shared.mainContext.delete(calories[indexPath.row])
//            
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            do {
//                try CoreDataStack.shared.mainContext.save()
//            } catch {
//                print("Failed to delete task: \(error)")
//            }
//        }
//    }
    @objc func cleanCalories(_ notification: Notification) {
        tableView?.reloadData()
        chart.removeAllSeries()
        chart.add(series)
    }
   
    func addCalories() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        var calorieTextField: UITextField?
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
            calorieTextField = textField
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let text = calorieTextField?.text else { return }
            let calorieData = Calorie(data: Double(text) ?? 0)
            self.calories.append(calorieData)
            self.chart.frame = CGRect(x: 0, y: 0, width: 50, height: 450)
            let index = Double(self.series.data.count)
            self.series.data.append((x: index, y: calorieData.data ))
            self.series.color = ChartColors.greenColor()
            self.series.area = true
            self.chart.add(self.series)
            self.tableView.reloadData()
            
            do {
                try CoreDataStack.shared.mainContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to save \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            self.dismiss(animated: true, completion: {
                
                self.show(self, sender: self.reloadInputViews())
                let nc = NotificationCenter.default
                nc.post(name: .cleanCalories, object: self)
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
}
