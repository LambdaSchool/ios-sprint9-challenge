//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Kat Milton on 8/23/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var calorieTableView: UITableView!
    @IBOutlet var calorieChart: Chart!

    var calorieCountController = CalorieCountController()
    let dateFormatter = DateFormatter()
    var calorieCounts = [Double]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieCount> = {
        let fetchRequest: NSFetchRequest<CalorieCount> = CalorieCount.fetchRequest()
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch: \(error)")
        }
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calorieTableView.delegate = self
        self.calorieTableView.dataSource = self
        calorieChart.frame = self.view.bounds
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.caloriesUpdated(notification:)),
                                               name: .caloriesUpdated,
                                               object: nil)
        setUpChart()
        
    }
    
    @objc func caloriesUpdated(notification: NSNotification) {
        try? fetchedResultsController.performFetch()
        setUpChart()
    }
    
    func setUpChart() {
        var label = [String]()
        var coordinates = [(x: Double, y: Double)]()
        if let chartData = fetchedResultsController.fetchedObjects?.compactMap({ Int($0.intakeNumber) }),
            let entryDate = fetchedResultsController.fetchedObjects?.compactMap({
                $0.date
            }) {
            var x = Double(0)
            
            for i in chartData {
                coordinates.append((x: x, y: Double(i)))
                x += Double(1)
            }
            
            for i in entryDate {
                var newLabel: String {
                    self.dateFormatter.dateStyle = .short
                    return self.dateFormatter.string(from: i)
                }
                
                label.append(newLabel)
            }
            
        }
        
        let series = ChartSeries(data: coordinates)
        series.area = true
        calorieChart.add(series)
        calorieChart.highlightLineColor = ChartColors.purpleColor()
        
        self.calorieTableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
        
        var calorieCountTextField: UITextField!
        alert.addTextField { (textField) in
            textField.placeholder = ""
            calorieCountTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let calorieCount = Double(calorieCountTextField.text!) else { return }
            self.calorieCountController.createEntry(with: calorieCount)
 
            NotificationCenter.default.post(name: .caloriesUpdated, object: nil)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        guard var frcObjects = fetchedResultsController.fetchedObjects else { return UITableViewCell() }
        let entry = frcObjects[indexPath.row]
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        guard let date = entry.date else { return UITableViewCell() }
  
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        cell.textLabel?.text = String(entry.intakeNumber)
        
        return cell
    }
    
    
}

extension CalorieTrackerViewController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            calorieTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieTableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            calorieTableView.deleteRows(at: [indexPath], with: .automatic)
            calorieTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieTableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sections = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            calorieTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            calorieTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}
