//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Linh Bouniol on 9/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var calorieController = CalorieController()
    
    var chartSeries = ChartSeries([])
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true),
                                        NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "name",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching: \(error)")
        }
        return frc
    }()
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addCalorie(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter your name and the amount of calories in the text fields", preferredStyle: .alert)
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Name:"
            titleTextField.keyboardType = .default
        }
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Calorie:"
            titleTextField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Sumbit", style: .default, handler: { (action) in
            guard let name = alert.textFields![0].text, name.count > 0 else { return }
            guard let calorie = alert.textFields![1].text, calorie.count > 0 else { return }
            guard let calorieCount = Int64(calorie), calorieCount >= 0 else { return }
            
            self.calorieController.create(name: name, calorie: calorieCount)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(calorieAdded), name: CalorieController.addedCalorieNotificaiton, object: nil)
        
        for calorie in calorieController.calories {
            chartSeries.data.append((x: Double(chartSeries.data.count), y: Double(calorie.calorie)))
        }
        chartSeries.color = ChartColors.pinkColor()
        chartSeries.area = true
        chart.add(chartSeries)
        
    }
    
    @objc func calorieAdded(notification: Notification) {
        guard let calorieCount = notification.userInfo?["calorie"] as? Int64 else { return }
        chartSeries.data.append((x: Double(chartSeries.data.count), y: Double(calorieCount)))
        
        chart.setNeedsDisplay()
        
//        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name.capitalized
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calorie.calorie)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        
        if let timestamp = calorie.timestamp {
            cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        }
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        // NSFetchedResultsChangeType has four types: insert, delete, move, update
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to:  newIndexPath)
            // Doesn't work any more?
//            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

}

