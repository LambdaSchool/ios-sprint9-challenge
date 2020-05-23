//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Ezra Black on 4/24/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class ViewController: UIViewController {

    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    let calorieController = CalorieController()
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
            return frc
        } catch {
            fatalError("Couldn't fetch from FRC: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieListUpdated, object: nil)
        updateViews()
    }
    
    @objc func updateViews() {
        tableView.reloadData()
        guard let sections = fetchedResultsController.sections else { return }
        calorieChart.removeAllSeries()
        var seriesDbls: [Double] = []
        for section in sections {
            if let objects = section.objects as? [Calorie] {
                for object in objects {
                    seriesDbls.append(Double(object.amount))
                }
            }
        }
        calorieChart.add(ChartSeries(seriesDbls))
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add calorie intake", message: "Enter the amount of calories", preferredStyle: .alert)
        alert.addTextField { txt in
            txt.placeholder = "Calories"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let txtField = alert.textFields,
                let calsTxt = txtField[0].text,
                let cals = Int(calsTxt)
            else {
                return
            }
            self.calorieController.create(amount: cals)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let calorie = fetchedResultsController.object(at: indexPath)
            calorieController.delete(calorie: calorie) { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        guard let timestamp = calorie.timestamp else {
            return UITableViewCell()
        }
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, YYYY at h:mm:ss"
        cell.textLabel?.text = "\(calorie.amount) Cal."
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
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
        // newIndexPath is option bc you'll only get it for insert and move
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
