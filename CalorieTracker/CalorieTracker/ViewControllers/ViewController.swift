//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Outlets & Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    var chartData = [Double]()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp",
                                                         ascending: true)]
        let mainContext = CoreDataManager.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> ViewController in fetchedResultsController: \(error)")
        }
        return fetchedResultsController
    }()
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    // MARK: - Actions & Methods
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // presents an alert and the alert handles the rest of the action
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        var calorieTextField: UITextField!
        alert.addTextField { (textField) in
            calorieTextField = textField
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            // TODO: populate the graph here?
            guard let calories = calorieTextField.text, !calories.isEmpty, let caloriesInt64 = Int64(calories) else { return }
            let date = self.dateFormatter.string(from: Date())
            let _ = Entry(calorieAmount: caloriesInt64, timeStamp: date)
            do {
                try CoreDataManager.shared.mainContext.save()
            } catch {
                print("Error saving new entry to CoreData: \(error)")
            }
            self.populateChart(with: caloriesInt64)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func populateChart(with newEntry: Int64) {
        
        chartData.append(Double(newEntry))
        let data = chartData
        let series = ChartSeries(chartData)
        chart.add(series)
        
    }
    
}

// MARK: - TableView data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else { fatalError() }
        cell.textLabel?.text = String(fetchedResultsController.object(at: indexPath).calorieAmount)
        cell.detailTextLabel?.text = fetchedResultsController.object(at: indexPath).timeStamp
        return cell
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
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
