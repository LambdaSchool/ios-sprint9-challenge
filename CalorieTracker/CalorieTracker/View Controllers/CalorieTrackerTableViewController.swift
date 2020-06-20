//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Harmony Radley on 6/19/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var chart: Chart!
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,                                                                                       managedObjectContext: context,
                                             sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }
        return frc
    }()

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        updateViews()
    }

    // MARK: - IBAction
    @IBAction func addButtonTapped(_ sender: Any) {
        createCalorieAlert()
    }

    // MARK: - Methods
    @objc private func updateViews() {
        tableView.reloadData()
        updateChart()
    }

    private func updateChart() {
        var count: [Double] = []
        let calories = fetchedResultsController.fetchedObjects ?? []

        for calories in calories {
            let calories = Double(calories.calorieAmount)
            count.append(calories)
        }

        let chartSeries = ChartSeries(count)
        chartSeries.area = true
        chart.add(chartSeries)
    }

    private func createCalorieAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the ammount of calories below:",
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            textField.keyboardType = .numberPad
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let textField = alert.textFields,
                let calorieString = textField[0].text,
                !calorieString.isEmpty,
                let calories = Double(calorieString) else { return }

            self.saveCalories(calories)

        }

        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }

    private func saveCalories(_ calorieAmount: Double, date: Date = Date()) {
        Calorie(calorieAmount: calorieAmount, date: date)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving to database: \(error)")
        }

        NotificationCenter.default.post(name: .chartUpdate, object: nil)
    }
}

// MARK: - Extension - Table view data source

extension CalorieTrackerTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorieResults = fetchedResultsController.object(at: indexPath)
        let calories = calorieResults.calorieAmount
        let date = calorieResults.date ?? Date()

        cell.textLabel?.text = "Calories: \(Int(calories))"
        cell.detailTextLabel?.text = "\(calorieResults.date ?? date)"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieData = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            do {
                context.delete(calorieData)
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(Notification(name: .chartUpdate, object: nil))
            } catch {
                context.reset()
                print("Error deleting object from managed object context: \(error)")
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
