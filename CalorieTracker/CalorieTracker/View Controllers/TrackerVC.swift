//
//  TrackerVC.swift
//  CalorieTracker
//
//  Created by Jeffrey Santana on 9/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class TrackerVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet private weak var graphView: Chart!
	@IBOutlet private weak var tableView: UITableView!
	
	// MARK: - Properties
	
	let intakeController = IntakeController()
	var sectionColors = [UIColor]()
	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
	
	lazy var fetchResultsController: NSFetchedResultsController<Intake> = {
		let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
		
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false),
										NSSortDescriptor(key: "calories", ascending: true)]
		
		let fetchControl = NSFetchedResultsController(fetchRequest: fetchRequest,
													  managedObjectContext: CoreDataStack.shared.mainContext,
													  sectionNameKeyPath: "user",
													  cacheName: nil)
		
		fetchControl.delegate = self
		
		do {
			try fetchControl.performFetch()
		} catch {
			fatalError("Error performing fetch for fetchControl: \(error)")
		}
		
		return fetchControl
	}()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		title = "Calorie Tracker"
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(refreshViews(notification:)),
											   name: .intakesFetched, object: nil)
		updateGraph()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .intakesFetched, object: nil)
	}
	
	// MARK: - IBActions
	
	@IBAction func addIntakeBtnTapped(_ sender: Any) {
		let intakeAlert = UIAlertController(title: "Add Calorie Intake", message: nil, preferredStyle: .alert)
		intakeAlert.addTextField { textfield in
			textfield.placeholder = "Name"
		}
		intakeAlert.addTextField { textfield in
			textfield.placeholder = "Calories"
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
			guard let user = intakeAlert.textFields?[0].optionalText, let calories = self.readCaloriesfrom(textfield: intakeAlert.textFields?[1]) else { return }
			self.intakeController.createIntake(user: user, calories: calories)
		}
		
		intakeAlert.addAction(cancelAction)
		intakeAlert.addAction(submitAction)
		present(intakeAlert, animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	private func readCaloriesfrom(textfield: UITextField?) -> Double? {
		guard let input = textfield?.optionalText else { return nil }
		if let calories = Double(input), calories >= 0 {
			return calories
		}
		
		return nil
	}
	
	private func updateGraph() {
		var seriesOfSeries = [ChartSeries]()
		var tempColors = [UIColor]()
		
		fetchResultsController.sections?.forEach({ section in
			var data = [0.0]
			section.objects?.reversed().forEach({ object in
				guard let intake = object as? Intake else { return }
				data.append(intake.calories)
			})
			let series = ChartSeries(data)
			let lineColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
			series.color = lineColor
			tempColors.append(lineColor)
			
			seriesOfSeries.append(series)
		})
		
		sectionColors = tempColors
		graphView.removeAllSeries()
		graphView.add(seriesOfSeries)
	}
	
	@objc func refreshViews(notification: Notification) {
		updateGraph()
		tableView.reloadData()
	}
}

// MARK: - TableView Datasource

extension TrackerVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = fetchResultsController.sections?[section]
		let intakes = section?.objects as? [Intake]
		if let section = section, let calories = intakes?.compactMap({ $0.calories }).reduce(0, +) {
			return "\(section.name) ~ \(Int(calories))"
		}
		return section?.name
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultsController.sections?[section].numberOfObjects ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeCell", for: indexPath)
		let intake = fetchResultsController.object(at: indexPath)
		
		cell.textLabel?.text = "Calories: \(Int(intake.calories))"
		cell.detailTextLabel?.text = dateFormatter.string(from: intake.timestamp!)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as? UITableViewHeaderFooterView
		header?.tintColor = sectionColors[section]
		header?.textLabel?.textColor = UIColor.white
	}
}

// MARK: - Fetched Results Delegate

extension TrackerVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: oldIndexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			fatalError("FetchedResulController bugged out")
		}
	}
	
	// swiftlint:disable:next line_length
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
}
