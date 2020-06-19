//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Nonye on 6/19/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet private weak var chartView: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
//    @IBOutlet weak var detailTextLabel: UILabel!
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, 'at' h:mm:ss a"
        return dateFormatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieData> = {
        let fetchRequest: NSFetchRequest<CalorieData> = CalorieData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "calories", ascending: true),
                                        NSSortDescriptor(key: "calorieDate", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "calorieDate",
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
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        addCalorieIntakeAlert()
    }
    
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
    
    private func saveCalories(_ calories: Double, caloriesDate: Date = Date()) {
        CalorieData(calories: calories, calorieDate: caloriesDate)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving task to database: \(error)")
        }
        NotificationCenter.default.post(name: .calorieAddedNotificationKey, object: nil)
    }
    
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
            
            self.saveCalories(calories)
        }
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
}

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

extension NSNotification.Name {
    static let calorieAddedNotificationKey = NSNotification.Name("calorieAddedNotificationKey")
}


