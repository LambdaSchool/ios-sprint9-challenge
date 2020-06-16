//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Kevin Stewart on 6/12/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    var chartedCalories = [Calories]()
    @IBOutlet var calorieChart: Chart!
    
    // MARK: - Fetch results
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching calories: \(error)")
        }
        return frc
    }()
    
    // MARK: - Outlets/Actions
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textFields = alert.textFields,
                let caloriesString = textFields[0].text,
                !caloriesString.isEmpty,
                let calories = Int(caloriesString) else { return }
            self.addCalorieIntake(calories: calories)
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(submit)
        self.present(alert, animated: true, completion:  nil)
    }
    
    private func addCalorieIntake(calories: Int) {
        Calories(calories: calories)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving calories: \(error)")
        }
        updateViews()
    }
    
    private func chartCalories() {
        let caloriesCharted = (fetchedResultsController.fetchedObjects?.compactMap { Double($0.calories)})!
        let series = ChartSeries(caloriesCharted)
        series.area = true
        series.color = ChartColors.greenColor()
        calorieChart.removeAllSeries()
        calorieChart.add(series)
    }
    
    func updateViews() {
        tableView.reloadData()
        chartCalories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieTrackerTableViewCell else { return UITableViewCell() }

        let fetchedCalories = fetchedResultsController.object(at: indexPath)
        cell.calories = fetchedCalories

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                let calorie = fetchedResultsController.object(at: indexPath)
                let moc = CoreDataStack.shared.mainContext
                DispatchQueue.main.async {
                    moc.delete(calorie)
                    do {
                        try moc.save()
                        self.updateViews()
                    } catch {
                        print("Error saving deleted task: \(error)")
                        moc.reset()
                }
            }
        }
    }
}

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
            
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
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
        default: //@unknown
            break
        }
    }
}
