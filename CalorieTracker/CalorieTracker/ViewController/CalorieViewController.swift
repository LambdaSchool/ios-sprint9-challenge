//
//  CalorieViewController.swift
//  CalorieTracker
//
//  Created by Bradley Diroff on 5/22/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
    }
    
    @IBAction func addTap(_ sender: Any) {
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "timestamp",
                                             cacheName: nil)
        frc.delegate = self
        do {
           try frc.performFetch()
        } catch {
            NSLog("Error loading managed object context: \(error)")
        }
        return frc
    }()
    
    func changeTheDate(_ date: Date) -> String {
        let dateDay = DateFormatter()
        let dateTime = DateFormatter()
        dateDay.dateFormat = "MMM dd, yyyy"
        dateTime.dateFormat = "hh:mm:ss"
        let day = dateDay.string(from: date)
        let time = dateTime.string(from: date)
        return "\(day) at \(time)"
    }

}

extension CalorieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? CalorieTableViewCell else {return UITableViewCell()}
        let entry = fetchedResultsController.object(at: indexPath)
        cell.calorieText.text = "Calories: \(entry.calories)"
        cell.dateText.text = changeTheDate(entry.timestamp ?? Date())
        return cell
    }
    
}

extension CalorieViewController: NSFetchedResultsControllerDelegate {
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
