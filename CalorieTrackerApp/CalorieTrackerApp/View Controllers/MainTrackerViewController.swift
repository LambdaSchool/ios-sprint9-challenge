//
//  MainTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit
import SwiftChart

class MainTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet var tableView: UITableView!
    
    var series: ChartSeries = ChartSeries([])
    var calorieData: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalorieEntryController.shared.loadFromPersistentStore()
        setCalorieData()
        updateViews()
        calorieChart.axesColor = .green
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .addCalorieEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addToCalorieData(_:)), name: .addCalorieEntry, object: nil)
        
    }
    
    @IBAction func addCalorieEntry(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calories", message: "Enter the amount of calories", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calories: "
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0]
            guard let caloriesString = textField?.text, let calories = Int(caloriesString) else {
                return }
            CalorieEntryController.shared.createCalorieEntry(calories: calories)
            NotificationCenter.default.post(name: .addCalorieEntry, object: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshViews(_ notifications: Notification) {
        updateViews()
    }
    
    @objc func addToCalorieData(_ notifications: Notification) {
        setCalorieData()
    }
    
    func setCalorieData() {
        var tempArray: [Double] = []
        for entry in CalorieEntryController.shared.calorieEntries {
            let calories = entry.calories
            tempArray.append(Double(calories))
        }
        calorieData = tempArray
        series = ChartSeries(calorieData)
        if !calorieChart.series.isEmpty {
            calorieChart.removeAllSeries()
        }
        calorieChart.add(series)
    }
    
    func updateViews() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalorieEntryController.shared.calorieEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath) as? CellCalorieTrackerTableViewCell else { return UITableViewCell() }
        
        let calorieEntry = CalorieEntryController.shared.calorieEntries[indexPath.row]
        cell.setOption(calorie: calorieEntry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieEntry = CalorieEntryController.shared.calorieEntries[indexPath.row]
            CalorieEntryController.shared.deleteCalorieEntry(calorieEntry: calorieEntry)
            calorieData.remove(at: indexPath.row)
            setCalorieData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
