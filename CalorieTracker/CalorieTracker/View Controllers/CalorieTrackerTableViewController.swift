//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Percy Ngan on 12/20/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	// MARK: - Outlets
	@IBOutlet weak var chart: Chart!

	// MARK: - Properties & Outlets
	let caloriesEntries: [CalorieEntry] = []
	let calorieEntryController = CalorieEntryController()
	lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {

		let fetchedRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
		fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "entryDate", ascending: true)]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		try! frc.performFetch()
		return frc

	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Calorie Tracker"

		DispatchQueue.main.async {
			self.updateViews()
		}

		NotificationCenter.default.addObserver(self, selector: #selector(updateViewConstraints), name: .calorieEntryAdded, object: nil)
	}

	// MARK: - SwiftChart methods
	@objc func newCalorieEntry(_ notification: Notification) {
		DispatchQueue.main.async {
			self.updateViews()
		}
	}

	@objc func updateViews() {

		let chartInput = fetchedResultsController.fetchedObjects!.count
		var enteredNumberOfCalories: [Double] = []
		for calories in 0..<chartInput {
			enteredNumberOfCalories.append(fetchedResultsController.fetchedObjects?[calories].numberOfCalories ?? 0.0)
		}
		let caloriesToChart = enteredNumberOfCalories
		let series = ChartSeries(caloriesToChart)
		series.area = true
		chart.add(series)
		chart.highlightLineColor = .green
		chart.axesColor = .green
		tableView.reloadData()
	}

	// MARK: - Actions
	@IBAction func addButtonTapped(_ sender: Any) {

		let notification = UIAlertController(title: "Add Calorie Entry", message: "Enter the number of calories", preferredStyle: .alert)
		var calorieEntryTextField: UITextField!
		notification.addTextField { (notificationTextField) in
			notificationTextField.placeholder = "Number of calories:"
			calorieEntryTextField = notificationTextField
		}
		let action = UIAlertAction(title: "Enter", style: .default) { (action) in
			let enteredNumberOfCalories = calorieEntryTextField.text ?? "0"
			self.calorieEntryController.addCalorieEntry(numberOfCalories: Double(enteredNumberOfCalories) ?? 0)
			NotificationCenter.default.post(name: .calorieEntryAdded, object: nil)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)

		notification.addAction(action)
		notification.addAction(cancel)
		present(notification, animated: true)
	}



	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)
		let calorieEntry = fetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = "\(calorieEntry.numberOfCalories)"

		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .medium
		if let entryDate = calorieEntry.entryDate {
			cell.detailTextLabel?.text = dateFormatter.string(from: entryDate)
		}

		return cell
	}

	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {

			//		let calorieEntry = fetchedResultsController.object(at: indexPath)
			//		calorieEntryController.deleteCalorieEntry(calorieEntry: calorieEntry)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}

	// MARK: - Table View Data Source Delegate Methods
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
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

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
			fatalError()
		}
	}
}

