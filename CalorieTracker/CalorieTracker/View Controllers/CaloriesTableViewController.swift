//
//  CaloriesTableViewController.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var calorieChart: Chart!
    private var chartSeries: [Double] = []
    var calorieController = CalorieController()
   lazy var fetchResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = CoreDataStack.shared.context
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "intake", cacheName: nil)
               fetchResultsController.delegate = self
    do {
         try fetchResultsController.performFetch()
    } catch {
        NSLog("failed to fetch Calories From Store: \(error.localizedDescription)")
    }
            return fetchResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    private func graphChart(withCalories calorie: Double) {
        self.chartSeries.append(calorie)
        let chartseries = ChartSeries(self.chartSeries)
       chartseries.area = true
       chartseries.line = true
       calorieChart.add(chartseries)
       calorieChart.gridColor = .gray
       chartseries.color = .blue
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell()}
        let calorie = fetchResultsController.object(at: indexPath)
        cell.calorie = calorie
        graphChart(withCalories: calorie.intake)
        return cell
    }
    @IBAction func addCalorieButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "enter the amount of calories in the field", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "enter amount"
        }
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let intakeString = alertController.textFields?[0].text else { return }
            if let intake = Double(intakeString) {
            self.calorieController.createIntake(withCalories: intake)
            } else {
                print("could not save intake lol")
            }
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension CaloriesTableViewController {
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
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
}
