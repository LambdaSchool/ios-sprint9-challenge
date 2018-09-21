//
//  CaloriesTableViewController.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
import PMAlertController

extension NSNotification.Name {
    static let shouldUpdateChart = NSNotification.Name("ShouldUpdateChart")
}

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet var chartView: UIView!
    var chart = Chart()
    var series = ChartSeries([])
    let nc = NotificationCenter.default
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let moc = CoreDataManager.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "date",
                                             cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    var calorieController = CalorieController()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    override func viewDidLoad() {
        chart = Chart(frame: CGRect(x: chartView.frame.origin.x,
                                    y: chartView.frame.origin.y,
                                    width: chartView.frame.width + 35,
                                    height: chartView.frame.height))
        chartView.addSubview(chart)
        
        nc.addObserver(self, selector: #selector(updateChart(_:)), name: .shouldUpdateChart, object: nil)
        nc.post(name: .shouldUpdateChart, object: self)
    }
    
    @objc func updateChart(_ notification: Notification) {
        if let data = fetchedResultsController.fetchedObjects?.compactMap({ Double($0.amount) }) {
            chart.removeAllSeries()
            series = ChartSeries(data)
            series.color = ChartColors.redColor()
            series.area = true
            chart.add(series)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTrackerCell", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath)
        let amount = String(calorie.amount)
        let date = dateFormatter.string(from: calorie.date ?? Date())
        
        cell.textLabel?.text = "Calories: \(amount)"
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    @IBAction func addCalories(_ sender: Any) {
        let alert = PMAlertController(title: "Add Calorie Intake", description: "Enter the amount of calories", image: nil, style: .alert)
        alert.addTextField { (textField) in
            textField?.placeholder = "Calories"
        }
        alert.addAction(PMAlertAction(title: "Submit", style: .default, action: { () in
            if let calories = alert.textFields.first?.text {
                self.calorieController.addCalories(amount: Int(calories) ?? 0)
                self.tableView.reloadData()
                self.nc.post(name: .shouldUpdateChart, object: self)
            }
        }))
        alert.addAction(PMAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
}
