//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by Ufuk Türközü on 27.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    let calorieController = CalorieController()
    
    lazy var fetchResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "date",
                                             cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChart),
                                               name: .updateChart, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let entry = fetchResultsController.object(at: indexPath)
        // Configure the cell...
        cell.textLabel?.text = "\(entry.calories) kcal"
        cell.detailTextLabel?.text = dateFormatter.string(from: entry.date ?? Date())
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                let entry = self.fetchResultsController.object(at: indexPath)
                self.calorieController.delete(entry: entry)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: .updateChart, object: self)
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Again?", message: "You said you would eat less 🙄", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "kcal:"
        }
        alert.addAction(UIAlertAction(title: "Let me live my life", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text, !calories.isEmpty {
                self.calorieController.create(with: Int16(calories) ?? 0, date: Date())
                NotificationCenter.default.post(name: .updateChart, object: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short
        return df
    }()
    
    @objc func updateChart() {
        let calories = fetchResultsController.fetchedObjects ?? []
        var calorieArr: [Double] = [0]
        
        for calorie in calories {
            calorieArr.append(Double(calorie.calories))
        }
        
        chartView.removeAllSeries()
        
        let series = ChartSeries(calorieArr)
        series.color = ChartColors.cyanColor()
        series.area = true
        
        chartView.add(series)
    }
    
}

extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
