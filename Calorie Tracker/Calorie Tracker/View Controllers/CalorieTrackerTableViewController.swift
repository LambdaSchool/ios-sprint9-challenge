//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Jesse Ruiz on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
// swiftlint:disable all

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Properties
    
    var chart: Chart?
    var data: [Double] = []
    
    let calorieTrackerController = CalorieTrackerController()
    
    var logs: [String] = []
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
    
    let date = Date(timeIntervalSinceNow: 0)
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
       
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        
        fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "date", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "date", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let calories = fetchedResultsController.fetchedObjects {
            data = calories.map({ Double($0.calorie!) }) as! [Double]
        }
        initChart()
        refreshViews()
        addObservers()
    }
    
    private func initChart() {
        let chartFrame = chartView.frame
        chart = Chart(frame: chartFrame)
        guard let chart = chart else { return }
        self.view.addSubview(chart)
    }
    
    // MARK: - Actions
    @IBAction func addLog(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
                
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0], let calorieLog = Int(textField.text!) {
            
            self.calorieTrackerController.createLog(with: String(calorieLog), date: Date(), context: CoreDataStack.shared.mainContext)
                self.data.append(Double(calorieLog))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogAdded"), object: self)
            }
        }))
            
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshViews),
                                               name: NSNotification.Name(rawValue: "LogAdded"),
                                               object: nil)
    }
    
    @objc private func refreshViews() {
        guard let chart = chart else { return }
        let series = ChartSeries(data)
        series.area = true
        chart.removeAllSeries()
        chart.add(series)
        tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieLog", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath).calorie
        
        cell.textLabel?.text = "Calories: \(String(describing: calorie))"
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        
        return cell
    }
}

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
