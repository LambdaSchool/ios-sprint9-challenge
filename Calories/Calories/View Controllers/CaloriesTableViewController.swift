//
//  CaloriesTableViewController.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(newCalorieAdded(_:)), name: .showChartDataChanged, object: nil)
    }
    
    @objc func newCalorieAdded(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateChartView()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caloriesController.calories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caloriesCell", for: indexPath)
        
        let calories = caloriesController.calories[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(calories.calories)"
        
        if calories.formattedDate != nil {
            cell.detailTextLabel?.text = "\(calories.formattedDate!)"
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let calorie = fetchedResultsController.object(at: indexPath)
            caloriesController.deleteCalories(calories: calorie)
            
            updateChartView()
        }
    }
    
    // MARK: - Alert Controller
    func showAlertController() {
        let alertController = UIAlertController(title: "Add Calories", message: "Enter the amount of calories", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calories = alertController.textFields?[0].text
            let caloriesDouble = Double(calories ?? "0")
            self.caloriesController.createCalories(calories: caloriesDouble!, date: Date())
            NotificationCenter.default.post(name: .showChartDataChanged, object: self)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateChartView() {
        guard let numbers = fetchedResultsController.fetchedObjects?.count else {return}
        var temporary: [Double] = []
        chartView.removeAllSeries()
        
        for number in 0..<numbers {
            temporary.append(Double(fetchedResultsController.fetchedObjects?[number].calories ?? 0.0))
        }
        
        calorieValues = temporary
        
        
        let chartSeries = ChartSeries(calorieValues)
        chartSeries.area = true
        chartView.add(chartSeries)
        chartView.setNeedsDisplay()
    }
    
    func clearChart() {
        data = [(0, 0.0)]
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true) ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlertController()
    }
    
    // MARK: - IBOUtlets
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Properties
    var caloriesController = CaloriesController()
    var calorieValues: [Double] = []
    private var data: [(Int, Double)] = [(0, 0.0)]
}

// MARK: - Extension
extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}
