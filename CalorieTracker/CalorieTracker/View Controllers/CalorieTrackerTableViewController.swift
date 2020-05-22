//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Mark Poggi on 5/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet private weak var chartView: Chart!

    // MARK: - Properties
    let calorieTrackerController = CalorieTrackerController()
    let calorieLogs: [CalorieLog] = []

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd, yyyy 'at' h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateViews()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieLogAdded, object: nil)

    }

    // MARK: - Methods

    @objc func updateViews() {
        let chartInput = fetchedResultsController.fetchedObjects!.count
        var calorieLogArray: [Double] = []
        for calories in 0..<chartInput {
            calorieLogArray.append(fetchedResultsController.fetchedObjects?[calories].numberOfCalories ?? 0.0)
        }
        let series = ChartSeries(calorieLogArray)
        series.color = ChartColors.blueColor()
        series.area = true
        chartView.add(series)

        chartView.gridColor = .blue
        chartView.highlightLineColor = .green
        chartView.axesColor = .green

        tableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        var calorieTrackerTextField: UITextField!
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Number of Calories:"
            calorieTrackerTextField = alertTextField
        }
        let action = UIAlertAction(title: "Submit", style: .default) { _ in
            let enterNumberofCalories = calorieTrackerTextField.text ?? "0"
            self.calorieTrackerController.addEntry(numberOfCalories: Double(enterNumberofCalories) ?? 0)
            NotificationCenter.default.post(name: .calorieLogAdded, object: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    // MARK: - Fetch Results Controller

    lazy var fetchedResultsController: NSFetchedResultsController<CalorieLog> = {
        let fetchRequest: NSFetchRequest<CalorieLog> = CalorieLog.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "logDate", ascending: true)]

        let context = CoreDataStack.shared.mainContext

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "logDate", cacheName: nil)

        frc.delegate = self

        do {

        try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieLogCell", for: indexPath)

        let calorieLog = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "Calories: \(calorieLog.numberOfCalories)"

        if let date = calorieLog.logDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = "No date has been provided."
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

extension Notification.Name {
    static let calorieLogAdded = Notification.Name("calorieLogAdded")
}
