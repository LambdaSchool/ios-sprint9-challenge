//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Andrew Liao on 9/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

private let moc = CoreDataStack.shared.mainContext

extension NSNotification.Name{
    static let entryWasAdded = NSNotification.Name("EntryWasAdded")
}

class CalorieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(entryWasAdded(_:)), name: .entryWasAdded, object: nil)
        
        
        setupChart()
    }
    // MARK: - Notification
    @objc func entryWasAdded(_ notification: Notification){
        tableView.reloadData()
    }
    
    // MARK: - Setup Chart
    func setupChart(){
//        calorieChart = Chart()
    }
    
    //MARK: - Add Action
    
    @IBAction func addEntry(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories you ate today", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard let input = alert.textFields?[0].text,
            let calories = Int(input) else {return}
            self.entryController.create(withCalories: calories)
            self.data.append((x: self.data.count, y: Double(calories)))
            self.calorieChart.add(ChartSeries(data: self.data))
            //Post notification
            self.nc.post(name: .entryWasAdded, object: self)
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert,animated:true, completion:nil)

    }
    
    func addEntryToChart() {
        
    }
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
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
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(entry.calories) calories"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        cell.detailTextLabel?.text = formatter.string(from: entry.date!)
        
        return cell
    }
    
    
    //MARK: - Properties
    @IBOutlet  var calorieChart: Chart!
    private let entryController = EntryController()
    private let nc = NotificationCenter.default
    private var data:[(Int, Double)] = []
    
    lazy var fetchedResultsController:NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
}
