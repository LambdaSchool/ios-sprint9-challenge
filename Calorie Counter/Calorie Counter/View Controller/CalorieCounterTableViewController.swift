//
//  CalorieCounterTableViewController.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieCounterTableViewController: UITableViewController {
    
    // MARK: Date Formatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }()
    
     // MARK: Properties
    
    var calorieController = CalorieController()
    var count: Int = 0
    var series: ChartSeries = ChartSeries([]) // array of empty chartseries
    var calorieData: [Double] = []
    
    // MARK: FRC
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results controller: \(error)")
        }
        return frc
    }()
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieController.loadFromPersistentStore()
        updateViews()
        setChartData()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: .newEntryAdded, object: nil)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let caloriesEntry = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(caloriesEntry.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: caloriesEntry.date ?? Date())
        return cell
    }
   
    // MARK: - IB Actions

    @IBAction func addBtnWasPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Caloric Intake", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Caloric Intake amount:"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let calories = alert.textFields?.first?.text, !calories.isEmpty {
                _ = Calorie(calories: Int16(calories) ?? 0, date: Date(), context: CoreDataStack.shared.mainContext)
                self.calorieController.saveToPersistentStore()
                
            }
        }))
        self.present(alert, animated: true)
    }
 
    func setChartData() {
        if let objects = fetchedResultsController.fetchedObjects {
            for entry in objects {
                calorieData.append(Double(entry.calories))
            }
        }
        let chartSeries = ChartSeries(calorieData)
        chartSeries.color = .blue
        chartSeries.area = true
        chartView.add(chartSeries)
        
//        var tempArray: [Double] = []
//        for entry in calorieController.calorieEntries {
//            let calories = entry.calories
//            tempArray.append(Double(calories)) // cast Int16 as double ..Int has no append
//        }
//        calorieData = tempArray
//        series = ChartSeries(calorieData)
//        if !chartView.series.isEmpty {
//            chartView.removeAllSeries()
//        }
//        chartView.add(series)
    }

    
    // update Views
    @objc func updateViews() {
        guard let calories = fetchedResultsController.fetchedObjects else { return }
        calorieController.calories = []
        for object in calories {
            self.calorieController.calories.append(Double(object.calories))
        }

        chartView.removeAllSeries()
        let chartSeries = ChartSeries(calorieData)
        chartSeries.color = .blue
        chartSeries.area = true
        chartView.add(chartSeries)
        tableView.reloadData()

    }
    
 
    
  
//    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {            
            let caloricIntake = fetchedResultsController.object(at: indexPath)
            calorieController.delete(for: caloricIntake)
            calorieData.remove(at: indexPath.row)
            setChartData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

// Extensions

extension CalorieCounterTableViewController: NSFetchedResultsControllerDelegate {
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
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

//// MARK: - ChartView Delegate
extension CalorieCounterTableViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {

    }

    func didFinishTouchingChart(_ chart: Chart) {

    }

    func didEndTouchingChart(_ chart: Chart) {

    }


}

// - Added Extension for NS Notification
extension NSNotification.Name {
    static let newEntryAddedToCoreData = NSNotification.Name("NewEntryAdded")
}
