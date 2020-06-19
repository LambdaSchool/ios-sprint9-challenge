//
//  CalorieTrackerTableViewController.swift
//  CALORIE-TRACKER
//
//  Created by Kelson Hartle on 6/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    lazy var fetchedResultController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc =  NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: context,
                                              sectionNameKeyPath: "timeStamp",
                                              cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
        
    }()
    
    let calorieEntryController = CalorieEntryController()
    
    var calorieAmount: String? {
        didSet {
            locateFetchedObjectsAndPlaceInArray()
            convertCalorieStringToDoubleAndCreateChart()
        }
    }
    var arrayThing: [String] = []

    @IBOutlet weak var chartFor: Chart?
    
    
    
    @objc func refreshViews(_ notification: Notification) {
            
            locateFetchedObjectsAndPlaceInArray()
            convertCalorieStringToDoubleAndCreateChart()
        }
        
        
        override func viewDidLoad() {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .caloriesHaveBeenAdded, object: nil)
            
            
            locateFetchedObjectsAndPlaceInArray()
            
            print(" OK \(fetchedResultController.fetchedObjects?.count ?? 0)")
            
            convertCalorieStringToDoubleAndCreateChart()
            
            chartFor?.delegate = self
            
            }
        
        func locateFetchedObjectsAndPlaceInArray() {
            guard let okay = fetchedResultController.fetchedObjects else { return }
            
            for i in okay {
                arrayThing.append(i.numOfCalories!)
                
            }
        }
        
        func convertCalorieStringToDoubleAndCreateChart() {
            var numbersArray: [Double] = []

            for i in arrayThing {
                guard let convertedI = Double(i) else { return }
                
                numbersArray.append(convertedI)
            }
            
            let series = ChartSeries(numbersArray)
            series.color = ChartColors.greenColor()
            chartFor?.add(series)
        }
        
        @IBAction func addNewTrackedCalories(_ sender: Any) {
            let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
            
                let action = UIAlertAction(title: "Submit", style: .default) { (action) in
                    let calorieAmountTXT = alert.textFields![0]
                    
                    self.calorieAmount = calorieAmountTXT.text
                    
                    let caloriesTracked = CalorieIntake(numOfCalories: self.calorieAmount!)
                    
                    self.calorieEntryController.sendTrackedCaloriesToServer(entry: caloriesTracked)
                    
                    print("OK \(self.calorieAmount!)")
                    
                    }
                
                let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

            alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter calories here"
            
            textField.keyboardType = .default
            }
            
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return fetchedResultController.sections?.count ?? 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return fetchedResultController.sections?[section].numberOfObjects ?? 0
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath) as? CalorieIntakeTableViewCell else { fatalError("Incorrect identifier")}
            
            cell.calorieIntake = fetchedResultController.object(at: indexPath)
                    
            return cell
        }
        
        
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                let calorieIntake = fetchedResultController.object(at: indexPath)
                calorieEntryController.deleteTrackedCaloriesFromServer(calorieIntake) { (result) in
                    guard let _ = try? result.get() else { return }
                    
                    DispatchQueue.main.async {
                        let context = CoreDataStack.shared.mainContext
                        context.delete(calorieIntake)
                        
                        do {
                            try context.save()
                        } catch {
                            context.reset()
                            NSLog("Error saving managed object context: \(error)")
                        }
                    }
                }
            }
        }
    }

    extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }// when controller sees that data has changed it runs this method.
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }//
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            default:
                break
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .move: //I.E. change the priority on  a task
                guard let oldIndexPath = indexPath,
                    let newIndexPath = newIndexPath else { return }
                tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete:
                guard let indexPath = indexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            @unknown default:
                break
            }
        }
    }


    extension CalorieTrackerTableViewController : ChartDelegate {
        func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
            
            for (seriesIndex, dataIndex) in indexes.enumerated() {
                if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                    print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
                }
            }
        }
        
        func didFinishTouchingChart(_ chart: Chart) {
            
        }
        
        func didEndTouchingChart(_ chart: Chart) {
            
        }
    
    
    
    
    
    
    
}
