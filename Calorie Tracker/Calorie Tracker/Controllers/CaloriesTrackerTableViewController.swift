//
//  CaloriesTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Bohdan Tkachenko on 8/15/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart


class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ChartDelegate {
    
    let calorieTrackerController = CalorieTrackerController()
    @IBOutlet weak var calorieChart: Chart! {
        didSet {
            addChartData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barButtonItems()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .caloriesAdded, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calorieTrackerController.fetchCalories()
        addChartData()
        
    }
    
    
    private func barButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
        self.addChartData()
    }
    
    @objc func addCalorie() {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of Calories in the field", preferredStyle: .alert)
        alertController.addTextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let submit = UIAlertAction(title: "Submit", style: .default, handler: { [unowned alertController] _ in
            if let caloriesCount = alertController.textFields?[0].text {
                if let caloriesCountInt = Double(caloriesCount) {
                    DispatchQueue.main.async {
                        self.submitCalories(caloriesCountInt)
                    }
                } else {
                    let errorAlertController = UIAlertController(title: "Invalid Entry", message: "enter a valid number", preferredStyle: .alert)
                    errorAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlertController, animated: true, completion: nil)
                }
            }
        })
        
        [cancel, submit].forEach { alertController.addAction($0) }
        present(alertController, animated:  true)
    }
    
    private func submitCalories(_ caloriesCount: Double) {
        
        CoreDataStack.shared.mainContext.performAndWait {
            let calorie = Calorie(calorieCount: caloriesCount)
            try? calorieTrackerController.save(calorie)
        }
        
        NotificationCenter.default.post(name: .caloriesAdded, object: nil)
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieTrackerController.countedCalories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = calorieTrackerController.countedCalories[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(calorie.calorieCount)"
        let formated = DateFormatter()
        formated.dateStyle = .medium
        formated.timeStyle = .short
        let dateString = formated.string(from: calorie.date!)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorie = calorieTrackerController.countedCalories[indexPath.row]
            let context = CoreDataStack.shared.mainContext
            
            context.delete(calorie)
            
            do {
                try context.save()
                calorieTrackerController.fetchCalories()
                tableView.reloadData()
            } catch {
                NSLog("Error saving context after deleting Calorie entry: \(error)")
                context.reset()
            }
        }
    }
    
    
}



extension CalorieTrackerTableViewController {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    func addChartData() {
        calorieChart.delegate = self
        calorieChart.xLabels = calorieTrackerController.getXLabels
        calorieChart.yLabels = calorieTrackerController.getYLabels
        
        let series = ChartSeries(data: calorieTrackerController.getData)
        series.area = true
        series.colors = (
            above: ChartColors.greenColor(),
            below: ChartColors.redColor(),
            zeroLevel: -1
        )
        self.calorieChart.backgroundColor = .white
        self.calorieChart.labelColor = .black
        self.calorieChart.gridColor = .black
        self.calorieChart.removeAllSeries()
        self.calorieChart.add(series)
    }
}

