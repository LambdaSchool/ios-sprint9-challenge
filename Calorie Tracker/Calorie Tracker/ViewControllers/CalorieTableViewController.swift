//
//  CalorieTableViewController.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTableViewController: UITableViewController {
    @IBOutlet private weak var chartView: Chart!

    let calorieController = CalorieController()
    
    var caloriesArray = [Double]()

    lazy var fetchedResultController: NSFetchedResultsController<Calorie> = {

        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "calorie", cacheName: nil)
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            print("Error fetching CoreDataStack: \(error)")
        }

        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieEntered, object: nil)
        updateViews()

    }

//    func dateString(for calorie: Calorie?) -> String? {
//        calorie?.timestamp.map { dateFormatter.string(from: $0) }
//    }
    
    @objc func updateViews() {
        fetchedResultController.fetchedObjects?.forEach { calorie in
            let calorie = calorie as Calorie
            caloriesArray.append(Double(calorie.calorie))
        }
        
        let series = ChartSeries(caloriesArray)
        self.chartView.gridColor = .gray
        self.chartView.removeAllSeries()
        self.chartView.add(series)
        series.area = true
        series.colors = (
        above: ChartColors.cyanColor(),
        below: ChartColors.redColor(),
        //Makes it to where if you put in an abnormal calorie number for your intake the chart colors turn red
        zeroLevel: 200
        )
    }
    

    @IBAction func addPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add calorie intake", message: "Please enter number of calories", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calorie Intake"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let calorieString = alert.textFields?.first?.text, !calorieString.isEmpty, let calories = Int16(calorieString) else { return }
            self.calorieController.create(calorie: calories, date: Date())
            self.caloriesArray.append(Double(calories))
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int    {
         fetchedResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultController.object(at: indexPath)
        if let date = calorie.timestamp {
            cell.textLabel?.text = "Calorie: \(calorie.calorie)"
            cell.detailTextLabel?.text = Date.dateToString(from: date)
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            caloriesArray.remove(at: indexPath.section)
            
        }
    }

//    private func updateChart() {
//        if let calories = fetchedResultController.fetchedObjects {
//            let series = ChartSeries(calories.map { Double($0.calorie) })
//            self.chartView.removeAllSeries()
//            self.chartView.add(series)
//            series.colors = (
//                above: ChartColors.blueColor(),
//                below: ChartColors.redColor(),
//                zeroLevel: 200
//            )
//        }
//    }
}

extension CalorieTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        self.updateViews()
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
        case.update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let toIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [toIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
