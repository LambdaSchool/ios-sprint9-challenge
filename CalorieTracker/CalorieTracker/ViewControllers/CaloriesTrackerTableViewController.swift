//
//  CaloriesTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Enzo Jimenez-Soto on 6/19/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var caloriesChart: UIView!
    
    let caloriesController = CaloriesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChart(notification:)),
                                               name: .updateChart, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .updateChart,
                                        object: self)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "added",
                                                         ascending: true),
                                        NSSortDescriptor(key: "added",
                                                         ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)
        
        let calories = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calories.calories ?? "0")"
        cell.detailTextLabel?.text = calories.date
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                let calories = self.fetchedResultsController.object(at: indexPath)
                self.caloriesController.deleteCalories(withCalorie: calories)
                self.tableView.reloadData()
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    @objc func updateChart(notification: Notification) {
        let calorieChart = Chart(frame: caloriesChart.frame)
        var data: [Double] = []
        for calorie in fetchedResultsController.fetchedObjects! {
            data.append(Double(calorie.calories!)!)
        }
        let series = ChartSeries(data)
        series.area = true
        calorieChart.add(series)
        self.caloriesChart.subviews.forEach({ $0.removeFromSuperview() })
        self.caloriesChart.addSubview(calorieChart)
    }
    
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
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    @IBAction func addCaloriesButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Calories", message: "Enter the amount of calories", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Calories:"
        }
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let caloriesCount = firstTextField.text else { return }
            self.caloriesController.createCalories(withCalorieCount: caloriesCount)
            NotificationCenter.default.post(name: .updateChart, object: self)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static var updateChart = Notification.Name("updateChart")
}
