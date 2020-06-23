//
//  CalorieTrackerViewController.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

/*

Put in a bar button item with system type 'add' and give it an IBAction
write in methods that will grab data via a UI alert and add it to core data
write in methods that add the data from core data to the views and update it when the user submits (use the notification center)
*/

class CalorieTrackerViewController: UIViewController {
    
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var caloriesTableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error performing initial fetch inside fetchedResultsController: \(error)")
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caloriesTableView.dataSource = self
        caloriesTableView.delegate = self
        updateViews()
        observeDataChanged()
    }
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        let submitCaloriesAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first?.text,
                let calories = Double(textField)
            else { return }
            
            CalorieTracker(calories: calories)
            

            do {
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(name: .caloriesEntered, object: self)
                self.caloriesTableView.reloadData()
            } catch {
                print("Error saving calories: \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(submitCaloriesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func observeDataChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .caloriesEntered, object: nil)
    }
    
    
    @objc private func updateViews() {
        let fetchedObjects = fetchedResultsController.fetchedObjects! as [CalorieTracker]
        var chartData: [Double] = []
        for fetchedObject in fetchedObjects {
            chartData.append(fetchedObject.calories)
        }
        
        let series = ChartSeries(chartData)
        series.color = ChartColors.greenColor()
        chartView.add(series)
    }
}

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = caloriesTableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }
        cell.calorieTracker = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
}

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        caloriesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        caloriesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            caloriesTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            caloriesTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            caloriesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            caloriesTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            caloriesTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            caloriesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            caloriesTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
