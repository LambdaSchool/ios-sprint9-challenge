//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/9/20.
//

import UIKit
import CoreData
import SwiftChart

class ViewController: UIViewController {
    
    @IBOutlet private var dataChart: UIView!
    @IBOutlet private var dataTable: UITableView!
    
    var caloriesController = CaloriesController()
    var chart = Chart()
    var series = ChartSeries([])
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching Calories objects: \(error)")
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .showNewData, object: nil)
        dataTable.delegate = self
        dataTable.dataSource = self
        chart = Chart(frame: dataChart.bounds)
        dataChart.addSubview(chart)
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .showNewData, object: self)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { alertText in
            alertText.keyboardType = .numberPad
            alertText.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            if let numCalories = alert.textFields![0].text,
               !numCalories.isEmpty,
               let finalNum = Double(numCalories) {
                self.caloriesController.addCalories(howMany: finalNum)
            }
            self.updateViews()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func updateViews() {
        var savedData: [Double] = []
        for entry in fetchedResultsController.fetchedObjects!.reversed() {
            savedData.append(entry.intake)
        }
        series = ChartSeries(savedData)
        series.area = true
        chart.add(series)
        dataChart.setNeedsDisplay()
        dataTable.reloadData()
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataTable.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataTable.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            dataTable.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            dataTable.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            dataTable.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            dataTable.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            dataTable.deleteRows(at: [oldIndexPath], with: .automatic)
            dataTable.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            dataTable.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath) as? CaloriesTableViewCell else {
            fatalError("Can't dequeue cell of type CalorieCell")
        }
        
        cell.numCalories = fetchedResultsController.object(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
