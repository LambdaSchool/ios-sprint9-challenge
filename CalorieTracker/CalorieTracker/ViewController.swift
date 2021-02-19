//
//  ViewController.swift
//  CalorieTracker
//
//  Created by John McCants on 10/9/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    
    var entries : [CalorieEntry] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: UIView!
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 318))
    var data = [
        (x: 0, y: 0.0),
    ]
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    func updateViews() {
        let series = ChartSeries(data: data)
        chart.add(series)
        series.color = ChartColors.greenColor()
        chartView.addSubview(chart)
    }
    
    func alertPresent() {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let caloriesText = alert.textFields?.first?.text else { return }
            let caloriesNumber = Double(caloriesText)!
            self.counter+=1
            
            let newEntry = CalorieEntry(calories: caloriesNumber, date: Date(), counter: self.counter)
            self.entries.append(newEntry)
            self.data.append((x: self.counter , y: caloriesNumber))
            self.updateViews()
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        alert.addTextField { (alertTextField) in
            
        }
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        alertPresent()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CalorieTableViewCell
        
        cell.caloriesLabel.text = "Calories: \(entries[indexPath.row].calories)"
        
        cell.dateLabel.text = "\(entries[indexPath.row].date)"
        
    return cell
    }
    
    
}

