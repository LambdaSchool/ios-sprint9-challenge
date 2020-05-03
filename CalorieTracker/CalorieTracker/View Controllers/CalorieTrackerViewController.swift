//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet private weak var intakeTableView: UITableView!
    @IBOutlet private weak var intakeChartView: Chart!

    let calorieIntakeController = CalorieIntakeController()
//    private var listOfCalories: [Double] = [0, 420, 700, 300]
//    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
//        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "date", ascending: false),
//        ]
//        let moc = CoreDataStack.shared.mainContext
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                             managedObjectContext: moc,
//                                             sectionNameKeyPath: "date",
//                                             cacheName: nil) // fetch results controller == frc
//        frc.delegate = self
//        //swiftlint:disable:next force_try
//        try! frc.performFetch()
//        return frc
//    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        intakeTableView.delegate = self
        intakeTableView.dataSource = self
        intakeTableView.reloadData()

//        let series = ChartSeries(calorieIntakeController.listOfCalories)
//        series.color = ChartColors.greenColor()
//        series.area = true
//        intakeChartView.minY = 0.0
//        intakeChartView.maxY = 1000
//        intakeChartView.add(series)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let series = ChartSeries(calorieIntakeController.listOfCalories)
        series.color = ChartColors.greenColor()
        series.area = true
        intakeChartView.minY = 0.0
        intakeChartView.maxY = 1000
        intakeChartView.add(series)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateViews),
                                               name: .newCalorieIntakeAddedNotificationName,
                                               object: nil)
    }

    @objc func updateViews() {
        intakeTableView.reloadData()
        let series = ChartSeries(calorieIntakeController.listOfCalories)
        series.color = ChartColors.greenColor()
        series.area = true
        intakeChartView.add(series)
    }

    // MARK: UITableView Delegates and Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieIntakeController.listOfIntakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = intakeTableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell",
                                                             for: indexPath) as? CalorieIntakeTableViewCell
            else { return UITableViewCell() }
        cell.calorieIntake = calorieIntakeController.listOfIntakes[indexPath.row]
        return cell
    }

    // MARK: IBActions
    @IBAction func addNewIntakeButton(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Add the amount of calories in the field",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField { textField in
            textField.placeholder = "Calories:"
        }
        //swiftlint:disable:next unused_closure_parameter
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            if let caloriesText = alert.textFields?.first?.text, let calories = Double(caloriesText) {
                self.calorieIntakeController.createIntake(withCalories: calories)
//                self.listOfCalories.append(calories)
            }
            NotificationCenter.default.post(name: .newCalorieIntakeAddedNotificationName, object: self)
        }))
        self.present(alert, animated: true)
    }
}

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        intakeTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        intakeTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            intakeTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            intakeTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            intakeTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            intakeTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            intakeTableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            intakeTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
