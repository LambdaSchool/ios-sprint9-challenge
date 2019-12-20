//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties

    @IBOutlet private weak var calorieChartView: Chart!
    @IBOutlet private weak var entryTableView: UITableView!

    private lazy var calorieEntryController = CalorieEntryController()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        calorieEntryController.delegate = self
        setUpChart()
        entryTableView.reloadData()
    }

    @IBAction func addEntryButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "Add calorie intake",
            message: "Enter the amount of calories in the field.",
            preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "# of calories"
        }

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "Add entry",
            style: .default,
            handler: { [unowned alert] _ in
                guard
                    let caloriesText = alert.textFields?[0].text,
                    let calories = Double(caloriesText)
                    else { return }

                _ = CalorieEntry(calories: calories)

                do {
                    try self.calorieEntryController.saveToPersistentStore()
                } catch {
                    NSLog("Error saving entry to persistent store: \(error)")
                }
        }))

        present(alert, animated: true, completion: nil)
    }

    func setUpChart() {
        var data = [Double]()
        if let entries = calorieEntryController.fetchedResultsController.fetchedObjects {
            data = entries.map { $0.calories }
        }
        calorieChartView.add(ChartSeries(data))
    }

    // MARK: - FetchedResultsController Delegate

    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        entryTableView.beginUpdates()
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        entryTableView.endUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            entryTableView.insertSections(
                IndexSet(integer: sectionIndex),
                with: .automatic)
        case .delete:
            entryTableView.deleteSections(
                IndexSet(integer: sectionIndex),
                with: .automatic)
        default:
            break
        }
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        let chartSeries = calorieChartView.series[0]

        switch type {
        case .insert:
            guard
                let newIndexPath = newIndexPath,
                let entry = anObject as? CalorieEntry
                else { return }
            entryTableView.insertRows(at: [newIndexPath], with: .automatic)
            chartSeries.data.insert(
                (x: Double(newIndexPath.row), y: entry.calories),
                at: newIndexPath.row)
        case .update:
            guard
                let indexPath = indexPath,
                let entry = anObject as? CalorieEntry
                else { return }
            entryTableView.reloadRows(at: [indexPath], with: .automatic)
            chartSeries.data[indexPath.row].y = entry.calories
        case .move:
            guard
                let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath,
                let entry = anObject as? CalorieEntry
                else { return }
            entryTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            entryTableView.insertRows(at: [newIndexPath], with: .automatic)
            chartSeries.data.remove(at: oldIndexPath.row)
            chartSeries.data.insert(
                (x: Double(newIndexPath.row), y: entry.calories),
                at: newIndexPath.row)
        case .delete:
            guard let indexPath = indexPath else { return }
            entryTableView.deleteRows(at: [indexPath], with: .automatic)
            chartSeries.data.remove(at: indexPath.row)
        @unknown default:
            break
        }
        
    }
}

// MARK: - Table View Data Source

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.entryCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EntryCell",
            for: indexPath)
        let entry = calorieEntryController.entry(at: indexPath)

        cell.textLabel?.text = String(entry.calories)
        cell.detailTextLabel?.text = "\(entry.timestamp ?? Date())"

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            calorieEntryController.deleteEntry(at: indexPath)
            updateChart()
        }
    }
}

// MARK: - Table View Delegate

extension CalorieTrackerViewController: UITableViewDelegate {}
