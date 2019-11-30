//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CaloriesTableViewController: UITableViewController {
    
    // MARK: Properties
    var newCalorieString = ""
    let intakeController = IntakeController()
//    var series: ChartSeries = ChartSeries([0.0, 0.0])
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChart()
        tableView.reloadData()
        
    }
    
    // MARK: Add new Intake Alert
    @IBAction func addIntakeButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Calorie", message: "Enter New Calorie Amount", preferredStyle: .alert)
        
        let calorieAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            
            // Getting textfield's text
            let amountTextField = alert.textFields![0]
            self.newCalorieString = amountTextField.text ?? ""
            
            
//            let _ = Intake(calories: Double(self.newCalorieString) as? Double)
//
//            do {
//                let moc = CoreDataStack.shared.mainContext
//                try moc.save()
//                print("Intake saved")
//            } catch {
//                NSLog("Error saving new intake in CD : \(error)")
//            }
//
            self.intakeController.createIntake(calories: self.newCalorieString)
            
            DispatchQueue.main.async {
                self.updateViews()
            }
            
            NotificationCenter.default.post(name: .newIntake, object: self)
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ( action) -> Void in })
        
        alert.addTextField(configurationHandler: { (textField: UITextField) in
            textField.placeholder = "Enter Calorie"
            textField.keyboardType = .default
        })
        
        alert.addAction(calorieAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func updateViews() {
//        let caloriesDouble = intakeController.fetchedResultsController.fetchedObjects?.compactMap({ Double($0.calories) })
        
//        series = ChartSeries(caloriesDouble ?? [0.0, 0.0])
        updateChart()
        tableView.reloadData()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .newIntake, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return intakeController.fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return intakeController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }
        
        cell.intake = intakeController.fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = intakeController.fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name
    }
    
    
    func updateChart() {
        
        var seriesList = [0.0]
        let caloriesDouble = intakeController.fetchedResultsController.fetchedObjects?.compactMap({ Double($0.calories) })
        guard let caloriesList = caloriesDouble else { return }
        
        for calorie in caloriesList {
            seriesList.append(calorie)
        }
        
        let series = ChartSeries(seriesList)
        series.area = true
        
        series.color = ChartColors.greenColor()
        chartView.removeAllSeries()
        chartView.add(series)
                
    }
    
    
}

extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert :
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update :
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move :
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete :
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default :
            break
            
        }
    }
}
