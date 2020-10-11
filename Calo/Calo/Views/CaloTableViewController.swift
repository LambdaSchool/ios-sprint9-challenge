//
//  CaloTableViewController.swift
//  Calo
//
//  Created by Gladymir Philippe on 10/11/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloTableViewController: UITableViewController {
    
    @IBOutlet private weak var chartView: Chart!

        // MARK: - Properties
        let caloriesController = CaloriesController()

        lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
            let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date",
                                                             ascending: true),
                                            NSSortDescriptor(key: "date",
                                                             ascending: true)
            ]
            let moc = CoreDataStack.shared.mainContext
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)

            frc.delegate = self

            do {
                try frc.performFetch()
            } catch {
                print("Error fetching")
            }
            return frc
        }()

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)
        }

        // MARK: - Methods
        @objc func updateChart(notification: Notification) {
            let calorieChart = Chart(frame: chartView.frame)
            var data: [Double] = []
            for calorie in fetchedResultsController.fetchedObjects! {
                data.append(Double(calorie.calorieAmount!) as! Double)
            }
            let series = ChartSeries(data)
            series.area = true
            calorieChart.add(series)
            self.chartView.subviews.forEach({ $0.removeFromSuperview() })
            self.chartView.addSubview(calorieChart)
        }

        // MARK: - IBAction
        @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
            let alertController = UIAlertController(title: "Add Calories", message: "Enter your calorie amount below", preferredStyle: .alert)
            alertController.addTextField { (textField: UITextField!) -> Void in
                textField.placeholder = "Enter Calories Here:"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let submitAction = UIAlertAction(title: "Add", style: .default, handler: { _ -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                guard let caloriesCount = firstTextField.text else { return }
                self.caloriesController.createCalorieEntry(with: caloriesCount)
                NotificationCenter.default.post(name: .updateChart, object: self)
                self.tableView.reloadData()

            })
            alertController.addAction(cancelAction)
            alertController.addAction(submitAction)
            self.present(alertController, animated: true, completion: nil)
        }
    
    
        // MARK: - Table view data source
        override func numberOfSections(in tableView: UITableView) -> Int {
            return self.fetchedResultsController.sections?.count ?? 1

        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)
            let calories = self.fetchedResultsController.object(at: indexPath)
            cell.textLabel?.text = "Calories: \(calories.calorieAmount ?? "0")"
            cell.detailTextLabel?.text = calories.dateAdded
            return cell
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let calorieEntry = self.fetchedResultsController.object(at: indexPath)
                self.caloriesController.deleteCalorieEntry(withCalorie: calorieEntry)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Extensions
    extension Notification.Name {
        static var updateChart = Notification.Name("updateChart")
    }

    extension CaloTableViewController: NSFetchedResultsControllerDelegate {
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
