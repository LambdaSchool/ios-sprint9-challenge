//
//  CalorieTrackerTableViewController.swift
//  Calorie-Tracker
//
//  Created by Marlon Raskin on 9/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

var dateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .long
	formatter.timeStyle = .short
	return formatter
}()

class CalorieTrackerTableViewController: UITableViewController {

	// MARK: - Properties & Outlets
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	let calorieController = CalorieController()

	lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
		let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
		let dateDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
		fetchRequest.sortDescriptors = [dateDescriptor]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc
	}()

	@IBOutlet private weak var chartView: Chart!

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(notification:)), name: .calorieHasBeenAdded, object: nil)
		addSeriesToChart()
    }


	// MARK: - IBActions
	@IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
		let alertAddCalories = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
		alertAddCalories.addTextField { calorieTextField in
			calorieTextField.placeholder = "Calorie Amount"
			calorieTextField.keyboardType = .numberPad
		}

		let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
			guard let amount = alertAddCalories.textFields?.first?.text else { return }
			self.calorieController.createCalorieEntry(amount: amount)
			self.addSeriesToChart()
		}
		
		let canceAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		[saveAction, canceAction].forEach { alertAddCalories.addAction($0) }
		present(alertAddCalories, animated: true, completion: nil)
	}


	// MARK: - Helper Methods
	func addSeriesToChart() {
		chartView.removeAllSeries()
		var calorieAmounts: [Double] = []

		for entry in calorieController.loadFromPersistentStore() {
			calorieAmounts.append(Double(entry.amount))
		}

		let series = ChartSeries(calorieAmounts)
		series.area = true
		series.color = #colorLiteral(red: 0.6254632995, green: 0.8229857427, blue: 0.3541799364, alpha: 0.8470588235)
		chartView.add(series)
	}


	@objc func refreshViews(notification: Notification) {
		addSeriesToChart()
		self.tableView.reloadData()
	}


	// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)

		let calorieEntry = fetchedResultsController.object(at: indexPath)
		guard let date = calorieEntry.dateAdded else { return UITableViewCell() }

		cell.textLabel?.text = "\(calorieEntry.amount)"
		cell.detailTextLabel?.text = dateFormatter.string(from: date)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieEntry = fetchedResultsController.object(at: indexPath)
            calorieController.deleteCalorieEntry(calorieEntry: calorieEntry)
			addSeriesToChart()
        }
    }
}

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
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

		let sectionIndexSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert:
			tableView.insertSections(sectionIndexSet, with: .automatic)
		case .delete:
			tableView.deleteSections(sectionIndexSet, with: .automatic)
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
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .fade)
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .fade)
		case .move:
			guard let indexPath = indexPath,
			 	let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		default:
			fatalError("Did not exhaust `type` options")
		}
	}
}
