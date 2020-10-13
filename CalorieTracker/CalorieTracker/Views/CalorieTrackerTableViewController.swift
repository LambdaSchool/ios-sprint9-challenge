//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Craig Belinfante on 10/11/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    let controller = CalorieController()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoad()
        tableView.reloadData()
        //  updateViews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var chart: Chart!
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add calories",
                                      message: "Enter calories below",
                                      preferredStyle: .alert)
        
        
        alert.addTextField { textField in
            textField.placeholder = ""
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let add = UIAlertAction(title: "Add", style: .default, handler: { (_) in
                let calories = Int(textField.text!) ?? 0
                
                self.controller.addCalories(calories: calories)
            })
            
            alert.addAction(cancel)
            alert.addAction(add)
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)
        let calories = fetchedResultsController.object(at: indexPath)
        let time = dateFormatter.string(from: (calories.time!))
        
        cell.textLabel?.text = "\(calories.calories) Calories \(time)"
        updateViews()
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections? [section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath:IndexPath) {
        if editingStyle == .delete {
            let calories = fetchedResultsController.object(at: indexPath)
            controller.removeCalories(calories: calories) { _ in
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }
}

extension CalorieTrackerTableViewController {
    private func updateViews() {
        var double: [Double] = []
        
        if let calories = fetchedResultsController.fetchedObjects {
            for object in calories {
                double.append(Double(object.calories))
            }
        }
        
        let updatedChart = ChartSeries(double)
        chart.add(updatedChart)
        updatedChart.color = ChartColors.yellowColor()
    }
}

//extension CalorieTrackerTableViewController {
//
//}

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
    // 4 to element
    // the same for any delegate method for an frc
    
    //Updates
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    //Sections
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections((IndexSet(integer: sectionIndex)), with: .automatic)
        case .delete:
            tableView.deleteSections((IndexSet(integer: sectionIndex)), with: .automatic)
        default:
            break
        }
    }
    
    // Rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}
