//
//  CaloriesTableViewController.swift
//  CaloriesApp
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CaloriesTableViewController: UITableViewController {
    @IBOutlet weak var chart: Chart!
    
    var calorieValues: [Double] = []
    var caloriesController = CaloriesController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchedRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        
        fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        
        let moc = CoreDataStack.shared.mainContext
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        try! fetchedResultController.performFetch()
        
        return fetchedResultController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(newCalorieAdded(_:)), name: .newCalorieEntryAdded, object: nil)
    }
    
    @objc func newCalorieAdded(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateChart()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caloriesCell", for: indexPath) as! CaloriesTableViewCell

        let calorie = fetchedResultsController.object(at: indexPath)
        
        cell.calories = calorie
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let calorie = fetchedResultsController.object(at: indexPath)
            
            caloriesController.deleteCalories(calorie: calorie)
            
            updateChart()
            
        }
    }
    
    func updateChart() {
        
        guard let numbers = fetchedResultsController.fetchedObjects?.count else {return}
        var temporary: [Double] = []
        chart.removeAllSeries()
        
        for number in 0..<numbers {
            temporary.append(Double(fetchedResultsController.fetchedObjects?[number].calorieAmount ?? 0.0))
        }
        
        calorieValues = temporary
        
        
        let chartSeries = ChartSeries(calorieValues)
        chartSeries.area = true
        chart.add(chartSeries)
        chart.setNeedsDisplay()
     
    }
   

   
    @IBAction func addCalorieEntryBarButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var caloriesTextField: UITextField!
        
        
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Calories:"
            caloriesTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            let calorieAmount = caloriesTextField.text ?? "0"
            
           
            self.caloriesController.addCalories(calorieAmount: Double(calorieAmount) ?? 0.0)
           
            NotificationCenter.default.post(name: .newCalorieEntryAdded, object: self)
            self.tableView.reloadData()
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
    
    //MARK: - NSFetchResultControllerDelegate
    
    //Tell the table view that were going to update
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    //tell the table were done updating
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //a single task
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
            //            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            //            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    //section related updates
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
