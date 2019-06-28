//
//  CalorieIntakeTableViewController.swift
//  CalorieChart
//
//  Created by Diante Lewis-Jolley on 6/28/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import UIKit
import SwiftChart
import Firebase
import CoreData

extension NSNotification.Name {
    static let createCalorieIntake = NSNotification.Name("CreatedCalorieIntake")
}



class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let formatter = DateFormatter()
    let calorieIntakeController = CalorieIntakeController()
    var series = ChartSeries([])
    @IBOutlet weak var chart: Chart!


    override func viewDidLoad() {
        super.viewDidLoad()

      setupChart()
        observeCalorieIntakeChanged()


    }

    private func setupChart() {

        chart.series.removeAll()

        guard var allcalories = fetchedResultsController.fetchedObjects?.map({$0.calorie}) else { return }
        allcalories.insert(0.0, at: 0)

        self.series = ChartSeries(allcalories)
        self.series.color = ChartColors.goldColor()
        self.series.area = true
        chart.add(self.series)
    }


    @IBAction func addCalorieButtonTapped(_ sender: Any) {

        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories ", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Calories: "
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in


            guard let calorieString = alert.textFields?.first?.text,
                let calories = Double(calorieString) else { return }
            self.calorieIntakeController.create(calories: calories)
            NotificationCenter.default.post(name: .createCalorieIntake, object: nil)
            

        }))

        self.present(alert, animated: true)
    }
    


    @objc func createCalorieIntake(_ notification: Notification) {

       setupChart()
    }

    func observeCalorieIntakeChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(createCalorieIntake(_:)), name: .createCalorieIntake, object: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorie = fetchedResultsController.object(at: indexPath)

        formatter.dateFormat = "MM/dd/yyyy 'at' hh:mm aaa"
        cell.textLabel?.text = "Calories: \(calorie.calorie)"
        cell.detailTextLabel?.text = calorie.timeStamp.map({timeStamp -> String in return formatter.string(from: timeStamp) })



        return cell
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let calorieIntake = fetchedResultsController.object(at: indexPath)

            calorieIntakeController.delete(calorieIntake: calorieIntake)
        }
        NotificationCenter.default.post(name: .createCalorieIntake, object: nil)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {

        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
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




    lazy var fetchedResultsController: NSFetchedResultsController<ColorieIntake> = {

        let fetchRequest: NSFetchRequest<ColorieIntake> = ColorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timeStamp", ascending: true)
        ]

        let moc = CoreDataStack.shared.mainContext

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self
        try! frc.performFetch()

        return frc
    }()

}
