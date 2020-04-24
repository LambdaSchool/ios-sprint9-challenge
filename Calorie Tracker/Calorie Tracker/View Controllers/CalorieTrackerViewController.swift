//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Wyatt Harrell on 4/24/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData
import SCLAlertView

extension NSNotification.Name {
    static let newEntryAddedToCoreData = NSNotification.Name("NewEntryAddedToCoreData")
}

class CalorieTrackerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var entries: [Double] = []
    let dateFormatter = DateFormatter()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupChart()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: .newEntryAddedToCoreData, object: nil)
    }
    
    // MARK: - Private Methods
    private func setupChart() {
        if let objects = fetchedResultsController.fetchedObjects {
            for entry in objects {
                entries.append(entry.numberOfCalories)
            }
        }
        let chartSeries = ChartSeries(entries)
        chartSeries.color = .red
        chartSeries.area = true
        calorieChart.add(chartSeries)
    }
    
    @objc private func updateViews(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let numberOfCalories = userInfo["Calories"] as? Double
        
        if let numberOfCalories = numberOfCalories {
            entries.append(numberOfCalories)
        }
        
        calorieChart.removeAllSeries()
        let chartSeries = ChartSeries(entries)
        chartSeries.color = .red
        chartSeries.area = true
        calorieChart.add(chartSeries)

        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        /*
        // MVP Alert Controller
        showAlert()
        */
        
        // Stretch Goal Alert Controller
        var textInput: String!
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Calories:")
        alert.addButton("Submit") {
            textInput = txt.text
            self.addEntry(with: textInput)
        }
        alert.addButton("Cancel") {
            //close
        }
        alert.showEdit("Add Calorie Intake", subTitle: "Enter the amount of calories in the field", colorStyle: 0xFF0707)
        
    }
    
    private func addEntry(with text: String) {
        guard let numberOfCalories = Double(text) else { return }
        
        Entry(numberOfCalories: numberOfCalories)
        
        do {
            try CoreDataStack.shared.save()
            NotificationCenter.default.post(name: .newEntryAddedToCoreData, object: self, userInfo: ["Calories": numberOfCalories])
        } catch {
            NSLog("Error saving managed object contect: \(error)")
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextfield: UITextField!
        
        alert.addTextField { textField in
            calorieTextfield = textField
            textField.placeholder = "Calories:"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let number = calorieTextfield.text, let numberOfCalorories = Double(number) else { return }
            
            Entry(numberOfCalories: numberOfCalorories)
            
            do {
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(name: .newEntryAddedToCoreData, object: self, userInfo: ["Calories": numberOfCalorories])
            } catch {
                NSLog("Error saving managed object contect: \(error)")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true),
                                        NSSortDescriptor(key: "numberOfCalories", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "timestamp", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error performing fetch \(error)")
        }
        return frc
    }()

}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        
        let entry = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(Int(entry.numberOfCalories))"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: entry.timestamp!))"

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
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
