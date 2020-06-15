//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

let notificationName = NSNotification.Name(rawValue: "updateUI")

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateChartData), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: notificationName, object: nil)
    }
    
    // MARK: - Notification Observers
    
    
    @objc func updateChartData() {
        if let data: [Double] = fetchedResultsController.fetchedObjects?.compactMap({Double($0.count)}) {
            let series = ChartSeries(data.reversed())
            chartView.add(series)
            chartView.setNeedsDisplay()
        }
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
    }
    
    @IBAction func addCalorieCount(_ sender: UIBarButtonItem) {
        showAddCalorieAlert()
    }
    
    @IBAction func deleteAllButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete all Entries", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteHandler(alert: UIAlertAction!) {
        deleteAllData("Calorie")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func deleteAllData(_ entity: String) {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
                try context.save()
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func showAddCalorieAlert() {
        let context = CoreDataStack.shared.mainContext
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Number of Calories"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
            guard let numberOfCalories = Int64(textField.text!) else { return }
            Calorie(count: numberOfCalories)
            
            do {
                try context.save()
                NotificationCenter.default.post(name: notificationName, object: nil)
            } catch {
                NSLog("Error saving Calorie Intake to context: \(error)")
                context.reset()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CalorieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.calorie = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    // MARK: - Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
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
        @unknown default:
            break
        }
    }
}

