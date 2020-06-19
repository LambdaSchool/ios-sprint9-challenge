// CalorieChartTableViewController.swift
//  CalorieTracker
//
//  Created by Joe Veverka on 6/19/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieChartTableViewController: UITableViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var chartView: Chart!
    
    //MARK: -Properties
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching: ", error)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(chartCals), name: .postedEntry, object: nil)
        chartCals()
    }
    
    //MARK: -Class Funcs
    
    @objc func chartCals() {
        var calories = [CalorieEntry]()
        for entry in fetchedResultsController.fetchedObjects ?? [] {
            calories.append(entry)
        }
        let data = calories.map {
            Double($0.calories)
        }
        let chartCals = ChartSeries(data)
        chartView.add(chartCals)
    }
    
    
    //MARK: -IBActions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        Alert.saveEntry(vc: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorieEntry = fetchedResultsController.object(at: indexPath)
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm:ss"
        cell.textLabel?.text = String(calorieEntry.calories)
        cell.detailTextLabel?.text = df.string(from: calorieEntry.date ?? Date())
        
        
        return cell
    }
}
extension CalorieChartTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent
        (_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
