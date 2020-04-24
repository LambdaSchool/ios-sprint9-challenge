//
//  CalorieTableViewController.swift
//  SprintCallengeWk11
//
//  Created by Bradley Diroff on 4/24/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

extension NSNotification.Name {
    static let calorieChanged = NSNotification.Name("calorieChanged")
}

class CalorieTableViewController: UITableViewController {
    
    @IBOutlet weak var chart: Chart!
    
    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createChart()
        NotificationCenter.default.addObserver(self, selector: #selector(createChart), name: .calorieChanged, object: nil)
    }
    
    
    @IBAction func addTap(_ sender: Any) {
          let alert = UIAlertController(
                title: "Please input calorie intake",
                message: "Enter the amount of calories.",
                preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = "# of calories"
            }

            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil))
            alert.addAction(UIAlertAction(
                title: "Add record",
                style: .default,
                handler: { [unowned alert] _ in
                    guard let caloriesText = alert.textFields?[0].text,
                        let calories = Int(caloriesText)
                        else { return }
                    do {
                        self.entryController.create(calories)
                        NotificationCenter.default.post(name: .calorieChanged, object: self)
                    }
            }))
            present(alert, animated: true, completion: nil)
        
    }
    
    @objc func createChart() {
         
        var calorieList: [CalorieEntry] = []
          for entry in fetchedResultsController.fetchedObjects ?? [] {
             calorieList.append(entry)
          }
          let entries = calorieList.map {
              Double($0.calories)
          }
          let allCalories = ChartSeries(entries)

          chart.add(allCalories)
      }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "timestamp", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        let entry = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(entry.calories)"
        
                let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm:ss"
        cell.detailTextLabel?.text = df.string(from: entry.timestamp ?? Date())

        return cell
    }

}

extension CalorieTableViewController: NSFetchedResultsControllerDelegate {
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

