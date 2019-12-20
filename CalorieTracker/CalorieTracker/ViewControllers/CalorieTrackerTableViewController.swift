//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_204 on 12/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
class CalorieTrackerTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var chartView: Chart!

    // MARK: - Properties
    let entryController = EntryController()
    let chartSeries = ChartSeries([])

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }

    lazy var fetchedResultController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieEntryAdded, object: nil)

        updateViews()
    }

    // MARK: - IBActions
    @IBAction func addCalorieEntry(_ sender: UIBarButtonItem) {
        presentCalorieEntryAlert()

    }

    // MARK: - Private Methods
    @objc func updateViews() {
        tableView?.reloadData()
        chartSeries.area = true
        chartSeries.color = ChartColors.blueColor()
        chartView.add(chartSeries)
    }

    private func presentCalorieEntryAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the amount of calories in the field",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            if let caloriesString = alert.textFields?.first?.text,
                !caloriesString.isEmpty,
                let calories = Float(caloriesString) {
                self.entryController.createEntry(calories: calories, timestamp: Date())
                let data = self.entryController.dataToChartSeries(for: calories)
                self.chartSeries.data.append(data)
                NotificationCenter.default.post(name: .calorieEntryAdded, object: self)
            }
        }))

        self.present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configure the cell...

        let calorieString = "Calories: \(fetchedResultController.object(at: indexPath).calories)"
        cell.textLabel?.text = calorieString

        // Fix this for a number formatter!!!
        let dateString = dateFormatter.string(from: fetchedResultController.object(at: indexPath).timestamp ?? Date())
        cell.detailTextLabel?.text = dateString

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
