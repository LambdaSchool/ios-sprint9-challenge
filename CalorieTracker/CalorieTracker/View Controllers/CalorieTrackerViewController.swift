//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Gerardo Hernandez on 5/4/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var chartView: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
      let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, 'at' h:mm:ss a"
        return dateFormatter
    }()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieData> = {
        let fetchRequest: NSFetchRequest<CalorieData> = CalorieData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true),
                                        NSSortDescriptor(key: "calories", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "timestamp",
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        updateViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieAddedNotificationKey, object: nil)
    }
    // MARK: - IBAction
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        addCalorieIntakeAlert()
    }
    
    // MARK: - Updates
    @objc private func updateViews() {
        tableView.reloadData()
        updateChart()
    }
    
    private func updateChart() {
        var count: [Double] = []
        let calories = fetchedResultsController.fetchedObjects ?? []
        
        for calories in calories {
            let calories = Double(calories.calories)
            count.append(calories)
            
        }
        let series = ChartSeries(count)
        series.area = true
        chartView.add(series)
    }
    // MARK: - Persistence
    private func persistCalories(_ calories: Double, timestamp: Date = Date()) {
        CalorieData(calories: calories, timestamp: timestamp)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving task to database: \(error)")
        }
        NotificationCenter.default.post(name: .calorieAddedNotificationKey, object: nil)
    }
    // MARK: - Alert
    private func addCalorieIntakeAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            textField.keyboardType = .numberPad
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textField = alert.textFields,
                let caloriesString = textField[0].text,
                !caloriesString.isEmpty,
                let calories = Double(caloriesString) else { return }
            
            self.persistCalories(calories)
        }
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - FRC Delegate
extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    
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

// MARK: - Table view data source
extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)
        let calorieData = fetchedResultsController.object(at: indexPath)
        let calories = calorieData.calories
        let timestamp = calorieData.timestamp ?? Date()
        
        cell.textLabel?.text = "Calories: \(Int(calories))"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieData = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            do {
                context.delete(calorieData)
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(Notification(name: .calorieAddedNotificationKey, object: nil))
            } catch {
                context.reset()
                print("Error deleting object from managed object context: \(error)")
            }
        }
    }
}
// MARK: - Notification Key
extension NSNotification.Name {
    static let calorieAddedNotificationKey = NSNotification.Name("calorieAddedNotificationKey")
}
