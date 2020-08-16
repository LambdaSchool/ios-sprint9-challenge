//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Josh Kocsis on 8/14/20.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    @IBOutlet weak var chartView: Chart!
    var data: [(Int, Double)] = []
    let calorieEntryController = CalorieEntry()
    let reuseIdentifier = "Calories"
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    lazy var fetchedResultsController: NSFetchedResultsController<Tracker> = {
        let fetchRequest: NSFetchRequest<Tracker> = Tracker.fetchRequest()
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "date", ascending: false)
        ]

        let context = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController<Tracker>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try? fetchedResultsController.performFetch()
        } catch {
            NSLog("Failed to fetch: \(error)")
        }
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        chartUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(caloriesAdded(_:)), name: .newCaloriesAdded, object: nil)
    }

    @IBAction func addCalories(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories you ate today", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
        guard let input = alert.textFields?[0].text,
                  let calories = Int16(input) else { return }
            self.calorieEntryController.create(calories: calories)
            self.data.append((x: self.data.count, y: Double(calories)))
            let series = ChartSeries(data: self.data)
            series.area = true
            self.chartView.add(series)
            NotificationCenter.default.post(name: .newCaloriesAdded, object: self)
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
        }

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func caloriesAdded(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func chartUpdate() {
        guard let entries = fetchedResultsController.sections?.first?.objects else {
            NSLog("No entries")
            return
        }
        for entry in entries {
            if let entry = entry as? Tracker {
                self.data.append((data.count, Double(entry.calories)))
            }
        }
        let series = ChartSeries(data: data)
        series.area = true
        chartView.add(series)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let tracker = fetchedResultsController.object(at: indexPath)
        guard let date = tracker.date else { fatalError("No Date") }

        cell.textLabel?.text = "Calories: \(tracker.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: date)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tracker = fetchedResultsController.object(at: indexPath)
            DispatchQueue.main.async {
                let context = CoreDataStack.shared.mainContext
                context.delete(tracker)
                do {
                    try context.save()
                } catch {
                    NSLog("Error saving after deleting: \(error)")
                }
                context.reset()
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
