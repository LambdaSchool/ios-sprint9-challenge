//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_201 on 2/22/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ChartDelegate {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            barButtonItems()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .caloriesAded, object: nil)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            calorieTrackerController.fetchTracks()
            addChartData()

            
        }
        

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return calorieTrackerController.trackedCalories.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }
            let tracked =  calorieTrackerController.trackedCalories[indexPath.row]
            
            cell.textLabel?.text = "Calories: \(tracked.caloriesCount!)" //Calories Cell.
                
            let formated = DateFormatter()
            formated.dateStyle = .medium
            formated.timeStyle = .short
            let dateString = formated.string(from: tracked.date!)
            cell.detailTextLabel?.text = dateString // Date cell.
     
            return cell
        }
        
        private func barButtonItems() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
            
            // MARK: Remove only for testing
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllCalories))
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
                    DispatchQueue.main.async {
                        self.submitCalories(caloriesCount)
                    }
                }
            })
            
            [cancel, submit].forEach { alertController.addAction($0) }
            present(alertController, animated:  true)
        }
        
        
        @objc func deleteAllCalories() {
            calorieTrackerController.deleteAll()
            chartView.add([])
            NotificationCenter.default.post(name: .caloriesAded, object: nil)
        }
        
        private func submitCalories(_ caloriesCount: String) {
            guard let _ = Int(caloriesCount) else {
                //send error
                return
            }
            
            CoreDataStack.shared.mainContext.performAndWait {
                let track = Track(caloriesCount: caloriesCount)
                try? calorieTrackerController.save(track)
            }
            
            NotificationCenter.default.post(name: .caloriesAded, object: nil)
        }
        
                
        let calorieTrackerController = CalorieTrackerController()
        @IBOutlet var chartView: Chart! {
            didSet {
                addChartData()
            }
        }
    }

    extension CalorieTableViewController {
        func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        }
        
        func didFinishTouchingChart(_ chart: Chart) {
        }
        
        func didEndTouchingChart(_ chart: Chart) {
        }
        
        
        func addChartData() {
            chartView.delegate = self
            chartView.xLabels = calorieTrackerController.getXLabels
            chartView.yLabels = calorieTrackerController.getYLabels
            
            let series = ChartSeries(data: calorieTrackerController.getData)
            series.area = true
            self.chartView.backgroundColor = .black
            self.chartView.labelColor = .white
            self.chartView.gridColor = .white
            chartView.removeAllSeries()
            chartView.add(series)
        }
}

