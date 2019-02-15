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
    static let caloriesDidChange = NSNotification.Name("cleanCalories")
}

class CalorieTableViewController: UITableViewController {
    
//    @IBAction func removeCalories(_ sender: Any) {
//      
//        chart.removeAllSeries()
//        do {
//            try CoreDataStack.shared.mainContext.save()
//            let nc = NotificationCenter.default
//            nc.addObserver(self, selector: #selector(caloriesDidChange(_:)), name: .caloriesDidChange, object: nil)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } catch {
//            print("Failed to delete task: \(error)")
//        }
//        calories = fetchCalorieFromStore()
//        
//    }
    
    
    func fetchCalorieFromStore() -> [Calorie] {
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        
        let resualt = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        return resualt
    }
    var caloriesIndex: [Int] = []
    var calories: [Calorie] = []
    var timestamp: [String] = []
    var series = ChartSeries([])
    var calorieData = Calorie()
    @IBAction func addCalorie(_ sender: Any) {
        addCalories()
        
    }
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(caloriesDidChange(_:)), name: .caloriesDidChange, object: nil)
        calories = fetchCalorieFromStore()
        navigationItem.title = "Calorie Tracker"
        
        
        for calorie in calories {
            let index = series.data.count
            let data = calorie.data
            series.data.append((x: Double(index), y: Double(data)))
            
        }
        
        chart.frame = CGRect(x: 0, y: 0, width: 250, height: 450)
        
        series.color = ChartColors.greenColor()
        chart.add(series)
       
        chart.xLabelsFormatter = { "Day \(Int (round($1)))" }
        
        series.area = true
        
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Calorie", for: indexPath) as? CalorieTableViewCell else { fatalError("No such cell")}
      
        cell.calorie.text = "Calorie: \(Int(calories[indexPath.row].data))" //" \(Int(data[indexPath.row]))"
        cell.timestamp.text = calories[indexPath.row].timestamp  //"\(timeFormatted)"
        
        func remove() {
            tableView.cellForRow(at: indexPath)?.removeFromSuperview()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let calorie = calories[indexPath.row]
            
            CoreDataStack.shared.mainContext.delete(calorie)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try CoreDataStack.shared.mainContext.save()
                let nc = NotificationCenter.default
                nc.addObserver(self, selector: #selector(caloriesDidChange(_:)), name: .caloriesDidChange, object: nil)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to delete task: \(error)")
            }
        }
        calories = fetchCalorieFromStore()
       
    }
    @objc func caloriesDidChange(_ notification: Notification) {
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
            self.calorieData = Calorie(data: Double(text) ?? 0)
            self.calories.append(self.calorieData)
            self.chart.frame = CGRect(x: 0, y: 0, width: 50, height: 450)
            let index = Double(self.series.data.count)
            self.series.data.append((x: index, y: self.calorieData.data ))
            self.series.color = ChartColors.greenColor()
            self.series.area = true
            self.chart.add(self.series)
            self.tableView.reloadData()
            
            do {
                try CoreDataStack.shared.mainContext.save()
                
            } catch {
                print("Failed to save \(error)")
            }
            let nc = NotificationCenter.default
            nc.post(name: .caloriesDidChange, object: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            self.dismiss(animated: true, completion: {
                
                self.show(self, sender: self.reloadInputViews())
                
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
}
