//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Bronson Mullens on 8/14/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func addCalorieButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Calories", message: "Enter the amount of calories", preferredStyle: .alert)
        alert.addTextField { txt in
            txt.placeholder = "Number of Calories"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let txtField = alert.textFields,
                let calsString = txtField[0].text,
                let calsInt = Int(calsString)
                else {
                    return
            }
            self.calorieController.create(calories: calsInt)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    let calorieController = CalorieController()
    
    static let reuseIdentifier = "CalorieCell"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "dateAdded", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
            return frc
        } catch {
            fatalError("Error: could not fetch from FRC")
        }
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieChart.axesColor = ChartColors.blueColor()
        calorieChart.highlightLineColor = ChartColors.blueColor()
        calorieChart.highlightLineWidth = 2
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieListUpdated, object: nil)
        updateViews()
    }
    
    // MARK: - Methods
    
    @objc func updateViews() {
        tableView.reloadData()
        guard let sections = fetchedResultsController.sections else { return }
        calorieChart.removeAllSeries()
        var series: [Double] = []
        for section in sections {
            if let objects = section.objects as? [Calories] {
                for object in objects {
                    series.append(Double(object.calories))
                }
            }
        }
        calorieChart.add(ChartSeries(series))
    }
    
}

extension Notification.Name {
    
    static var calorieListUpdated = Notification.Name("CalorieListUpdated")
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorie = fetchedResultsController.object(at: indexPath)
            calorieController.delete(calories: calorie) { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        guard let dateAdded = calorie.dateAdded else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a - MMM d Y"
        cell.textLabel?.text = "Calories: \(calorie.calories)"
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        cell.detailTextLabel?.text = dateFormatter.string(from: dateAdded)
        return cell
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
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
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
}
