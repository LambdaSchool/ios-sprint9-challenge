//
//  CaloriesViewController.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CaloriesViewController: UIViewController {

	lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
		let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "person", ascending: true), NSSortDescriptor(key: "timestamp", ascending: false)]

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: moc,
																  sectionNameKeyPath: "person",
																  cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}()
	let caloriesController = CaloriesController()

	@IBOutlet var tableView: UITableView!
	@IBOutlet var chartParentView: UIView!
	let chart = Chart()
	var peoplesSeries = [UUID: ChartSeries]()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupChart()
//		setupNotificationObserver()
	}

	func setupChart() {
		chartParentView.addSubview(chart)

		chart.minY = 0
		chart.translatesAutoresizingMaskIntoConstraints = false
		chart.topAnchor.constraint(equalTo: chartParentView.topAnchor).isActive = true
		chart.bottomAnchor.constraint(equalTo: chartParentView.bottomAnchor).isActive = true
		chart.leadingAnchor.constraint(equalTo: chartParentView.leadingAnchor).isActive = true
		chart.trailingAnchor.constraint(equalTo: chartParentView.trailingAnchor).isActive = true
	}

	func setupNotificationObserver() {
		NotificationCenter.default.addObserver(forName: .caloriesUpdated, object: nil, queue: nil) { [weak self] (notification) in
			guard let personSections = self?.fetchedResultsController.sections else { return }
			for person in personSections {
				guard let calories = person.objects as? [Calories] else { continue }
				guard let personID = UUID(uuidString: person.name) else { continue }
				var datas = [Double]()
				for caloriesObject in calories {
					datas.append(caloriesObject.calories)
				}
				if let series = self?.peoplesSeries[personID] {
					let start = series.data.count
					for index in start..<datas.count {
						series.data.append((x: Double(index), y: datas[index]))
					}
					self?.chart.add(series)
				} else {
					let series = ChartSeries(datas)
					self?.chart.add(series)
				}
			}
		}
	}

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add Calorie Intake", message: "Careful what you eat!", preferredStyle: .alert)
		var calorieTextField: UITextField?
		alert.addTextField { (textField) in
			calorieTextField = textField
			calorieTextField?.addTarget(self, action: #selector(self.calorieTextFieldEdited), for: .editingChanged)
		}
		let action = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
			guard let calorieString = calorieTextField?.text, let calorieAmount = Double(calorieString) else { return }
			self?.caloriesController.create(calories: calorieAmount)
			NotificationCenter.default.post(name: .caloriesUpdated, object: nil)
//			if let series = self?.chart.series.first {
//				series.data.append((x: Double(series.data.count), y: calorieAmount))
//				self?.chart.add(series)
//			} else {
//				let series = ChartSeries([calorieAmount])
//				self?.chart.add(series)
//			}

		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(action)
		alert.addAction(cancel)
		present(alert, animated: true)
	}

	@IBAction func calorieTextFieldEdited(_ sender: UITextField) {
		sender.text = sender.text?.replacingOccurrences(of: ##"\D"##, with: "", options: .regularExpression, range: nil)
	}
}

extension CaloriesViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
		guard let calorieCell = cell as? CalorieTableViewCell else { return cell }
		calorieCell.calories = fetchedResultsController.object(at: indexPath)
		return calorieCell
	}
}

// MARK: - Fetched Results Controller Delegate
extension CaloriesViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		let indexSet = IndexSet([sectionIndex])
		switch type {
		case .insert:
			tableView.insertSections(indexSet, with: .automatic)
		case .delete:
			tableView.deleteSections(indexSet, with: .automatic)
		default:
			print(#line, #file, "unexpected NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		@unknown default:
			print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return nil
	}
}

