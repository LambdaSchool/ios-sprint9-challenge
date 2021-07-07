//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Properties
    
    var chart: Chart?
    let notificationCenter = NotificationCenter.default
    let calorieTrackerController = CalorieController()
    
    var data = [Double]()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, h:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    let date = Date(timeIntervalSinceNow: 0)
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "date", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch  {
            print("Error fetching calorie entries: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCalories()
        chartInitliazer()
        refresh()
        registerNotifications()
        
    } 
    
    
    // MARK: - Actions
    
    @IBAction func addInput(_ sender: UIBarButtonItem) {
        // add alert Controller for input here
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0], let calories = Int(textField.text!) {
                
                self.calorieTrackerController.addCalories(calorie: String(calories), date: Date(), context: CoreDataStack.shared.mainContext)
                self.data.append(Double(calories))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InputAdded"), object: self)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Other Functions
    
    func fetchCalories() {
        if let calories = fetchedResultsController.fetchedObjects {
            data = calories.map({ Double($0.calorie!) }) as! [Double]
        }
    }
    
    func chartInitliazer() {
        let chartFrame = chartView.frame
        chart = Chart(frame: chartFrame)
        guard let chart = chart else { return }
        self.view.addSubview(chart)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh),
                                               name: NSNotification.Name(rawValue: "InputAdded"),
                                               object: nil)
    }
    
    @objc private func refresh() {
        guard let chart = chart else { return }
        let series = ChartSeries(data)
        series.area = true
        chart.removeAllSeries()
        chart.add(series)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath).calorie
        let date = fetchedResultsController.object(at: indexPath).date
        
        cell.textLabel?.text = "Calories: \(String(describing: calorie!))"
        cell.detailTextLabel?.text = dateFormatter.string(from: date!)
        
        return cell
    }
}


// MARK: - Extensions
extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
    
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
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
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
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default:
            return
        }
    }
    
}
