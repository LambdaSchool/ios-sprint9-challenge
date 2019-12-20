//
//  CalorieIntakesTableViewController.swift
//  SprintChallengeCalorieTracker
//
//  Created by morse on 12/20/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieIntakesTableViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak var chart: Chart!

    // MARK: - Properties

    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PropertyKeys.date, ascending: true)]

        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: PropertyKeys.date, cacheName: nil)

        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }

        return frc
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath)

        cell.textLabel?.text = "Calories: \(fetchedResultsController.object(at: indexPath).calorieCount)"
        cell.detailTextLabel?.text = "date"

        return cell
    }

    // MARK: - Actions

    @IBAction func addIntake(_ sender: Any) {
        let alert = UIAlertController(title: "Add calories?", message: "Type the number of calories you consumed today.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.add(calorieCount: alert.textFields?[0].text ?? "")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textfield in textfield.placeholder = "Calories" })

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Private

    private func add(calorieCount: String) {
        guard let calories = Int(calorieCount) else { return /* add alert? */}
        CalorieIntake(calorieCount: calories)
    }

    private func save() {
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            print("Error saving to CoreDataStack: \(error)")
        }
    }
}

extension CalorieIntakesTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}
