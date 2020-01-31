//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Chad Rutherford on 1/31/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
//

import CoreData
import SwiftChart
import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    @IBOutlet private weak var chart: Chart!
    var calorieController = CalorieController()
    var caloriesArray = [Double]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlert))
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieEntered, object: nil)
        updateViews()
    }
    
    @objc private func updateViews() {
        fetchedResultsController.fetchedObjects?.forEach { entry in
            let entry = entry as Entry
            caloriesArray.append(Double(entry.calories))
        }
        let series = ChartSeries(caloriesArray)
        series.color = ChartColors.cyanColor()
        series.area = true
        chart.add(series)
    }
    
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Please enter the number of calories below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter Calories:"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let calorieString = alert.textFields?.first?.text, !calorieString.isEmpty, let calories = Int(calorieString) else { return }
            self.calorieController.addEntry(calories: calories, date: Date())
            self.caloriesArray.append(Double(calories))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .calorieCell, for: indexPath)
        let entry = fetchedResultsController.object(at: indexPath)
        if let date = entry.date {
            cell.textLabel?.text = "Calories: \(entry.calories)"
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        return cell
    }
}

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [fromIndexPath], with: .automatic)
            tableView.insertRows(at: [toIndexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
