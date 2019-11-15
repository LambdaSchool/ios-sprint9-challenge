//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Gi Pyo Kim on 11/15/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTableViewController: UITableViewController {

    @IBOutlet weak var chartView: Chart!
    
    var chart: Chart?
    var datas: [Double] = []
    
    let calorieController = CalorieController()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
       
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "date", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let calories = fetchedResultsController.fetchedObjects {
            datas = calories.map ({ Double($0.calorie) })
        }
        initChart()
        updateSeries()

        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSeries), name: Notification.Name("newCalorieAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSeries), name: Notification.Name("calorieDeleted"), object: nil)
    }
    
    // MARK: - Charts
    private func initChart() {
        let chartFrame = chartView.frame
        chart = Chart(frame: chartFrame)
        guard let chart = chart else { return }
        self.view.addSubview(chart)
    }

    @objc private func updateSeries() {
        guard let chart = chart else { return }
        let series = ChartSeries(datas)
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
        guard let date = fetchedResultsController.object(at: indexPath).date else { return UITableViewCell() }
        
        cell.textLabel?.text = "Calories: \(calorie)"
        cell.detailTextLabel?.text = dateFormatter.string(from: date)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            calorieController.deleteCalorie(calorie: fetchedResultsController.object(at: indexPath), context: CoreDataStack.shared.mainContext)
            
            // update chart
            if let calories = fetchedResultsController.fetchedObjects {
                datas = calories.map ({ Double($0.calorie) })
            }
            NotificationCenter.default.post(name: Notification.Name("calorieDeleted"), object: self)
        }
    }


    @IBAction func addButtonTabbed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "calories"
        }

        alert.addAction(UIAlertAction(title: "Sumbit", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0], let calorieString = textField.text, let calorie = Int16(calorieString) {
                
                self.calorieController.createCalorie(calorie: calorie, date: Date(), context: CoreDataStack.shared.mainContext)
                self.datas.append(Double(calorie))
                NotificationCenter.default.post(name: Notification.Name("newCalorieAdded"), object: self)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CalorieTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
        
    }
}
