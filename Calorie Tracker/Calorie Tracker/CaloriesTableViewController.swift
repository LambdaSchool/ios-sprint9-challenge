//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by Karen Rodriguez on 4/24/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var chartUIView: Chart!


    // MARK: - Properties
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        return formatter
    }()
    var data: [Double] = [] {
        didSet {
            updateChart()        }
    }


    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {

        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        let context = CoreDataStack.shared.mainContext

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc

    }()

    // MARK: - Methods

    private func updateChart() {
        let series = ChartSeries(data)
        series.area = true
        chartUIView.removeAllSeries()
        chartUIView.add(series)
        chartUIView.reloadInputViews()
    }

    @objc func notificationCall(_ notification: Notification) {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving newly created entry")
        }
    }

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCall(_:)), name: .caloriesSubmitted, object: nil)
//        let newEntry = Entry(calories: 190, date: Date(), context: CoreDataStack.shared.mainContext)
//        try! CoreDataStack.shared.save()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "caloriesEntryCell", for: indexPath) as? CaloriesEntryTableViewCell else { return UITableViewCell() }

        let entry = fetchedResultsController.object(at: indexPath)
        cell.formatter = formatter
        cell.entry = entry
        data.append(entry.calories)
        return cell
    }

    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let fields = alert.textFields,
                let text = fields[0].text,
            let calories = Double(text) else { return }
            Entry(calories: calories)
            NotificationCenter.default.post(name: .caloriesSubmitted, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }


    // MARK: - FRC Delegate Methods

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
