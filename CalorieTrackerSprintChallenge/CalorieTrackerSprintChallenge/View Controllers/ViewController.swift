//
//  ViewController.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    // MARK: - IBOutlets and Properties
    var entryController = CalorieEntryController()
    var entriesArray: [CalorieEntryRep] = []
    let df = DateFormatter()
    var series: ChartSeries?
    lazy var frc: NSFetchedResultsController<CalorieEntry> = {
        
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "timestamp",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var calorieEntryTableView: UITableView!
    
    // MARK: - IBActions and Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryTableView.delegate = self
        calorieEntryTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .newEntry, object: nil)
        self.updateViews()
    }
    
    @IBAction func addCalorieEntryTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Entry", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter Calorie Amount"
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let calorieAmount = alert.textFields?.first?.text,
                !calorieAmount.isEmpty else { return }
            self.entryController.createEntry(amount: calorieAmount, timestamp: Date())
//            self.updateViews()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    @objc func updateViews() {
        let array: [Double] = entriesArray.compactMap({ Double($0.amount) })
        series?.color = ChartColors.greenColor()
        series = ChartSeries(array)
        calorieChart.add(series!)
        calorieChart.reloadInputViews()
        calorieEntryTableView.reloadData()
    }
    
}

// MARK: - ViewController Extensions
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calorieEntryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = frc.object(at: indexPath)
        guard let timestamp = entry.timestamp else { return UITableViewCell() }
        df.dateStyle = .medium
        df.timeStyle = .short
        
        cell.textLabel?.text = entry.amount
        cell.detailTextLabel?.text = df.string(from: timestamp)
        
        return cell
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieEntryTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieEntryTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            calorieEntryTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieEntryTableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            calorieEntryTableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieEntryTableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            calorieEntryTableView.insertSections(indexSet, with: .automatic)
        case .delete:
            calorieEntryTableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}
