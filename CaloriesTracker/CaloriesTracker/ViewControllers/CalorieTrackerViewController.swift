//
//  CalorieTrackerViewController.swift
//  CaloriesTracker
//
//  Created by Ian French on 8/16/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart


class CalorieTrackerViewController: UIViewController {

    @IBOutlet weak var chart: Chart!

    @IBOutlet weak var calorieTable: UITableView!

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        createCalorieAlert()
    }

    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calorieTable.dataSource = self
        updateViews()
        observerChanged()
    }

    func observerChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .chartUpdate, object: nil)
    }



    // MARK: - Methods
    @objc private func updateViews() {
        calorieTable.reloadData()

        updateChart()
    }

    private func updateChart() {
        var count: [Double] = []
        let calories = fetchedResultsController.fetchedObjects ?? []

        for calories in calories {
            let calories = Double(calories.calorieValue)
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
        Calorie(calorieValue: calorieAmount, date: date)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving to database: \(error)")
        }

        NotificationCenter.default.post(name: .chartUpdate, object: nil)
    }
}

// MARK: - Extension - Table view data source

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorieResults = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "Calories: \(calorieResults.calorieValue) at  \(calorieResults.date ?? "")"
        // cell.detailTextLabel?.text = "\(calorieResults.date ?? "")"

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

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTable.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTable.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            calorieTable.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieTable.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            calorieTable.deleteRows(at: [oldIndexPath], with: .automatic)
            calorieTable.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieTable.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break

        }
    }
}

extension NSNotification.Name {
    static let chartUpdate = NSNotification.Name("chartUpdate")
}
