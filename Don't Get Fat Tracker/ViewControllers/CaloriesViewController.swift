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
		return newFetchedResults()
	}()
	let caloriesController = CaloriesController()

	@IBOutlet var tableView: UITableView!
	@IBOutlet var chartParentView: UIView!
	let chart = Chart()
	var peoplesSeries = [UUID: ChartSeries]()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupChart()
		setupNotificationObserver()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.post(name: .caloriesUpdated, object: nil)
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
			guard let self = self else { return }
			self.fetchedResultsController = self.newFetchedResults()
			self.tableView.reloadData()
			guard let personSections = self.fetchedResultsController.sections else { return }
			for person in personSections {
				guard let calories = person.objects as? [Calories] else { continue }
				guard let personID = UUID(uuidString: person.name) else { continue }
				var datas = [Double]()
				for caloriesObject in calories.reversed() {
					datas.append(caloriesObject.calories)
				}
				if let series = self.peoplesSeries[personID] {
					series.data.removeAll()
					let seriesData: [(x: Double, y: Double)] = datas.enumerated().map { (x: Double($0.offset), y: $0.element) }
					series.data = seriesData
					self.peoplesSeries[personID] = series
					self.chart.add(series)
				} else {
					let series = ChartSeries(datas)
					self.peoplesSeries[personID] = series
					self.chart.add(series)
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

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let calories = fetchedResultsController.object(at: indexPath)
			caloriesController.delete(calories: calories)
			NotificationCenter.default.post(name: .caloriesUpdated, object: nil)
		}
	}
}

// MARK: - Fetched Results Controller Delegate
extension CaloriesViewController {

	func newFetchedResults() -> NSFetchedResultsController<Calories> {
		let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "person", ascending: true), NSSortDescriptor(key: "timestamp", ascending: false)]

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																  managedObjectContext: moc,
																  sectionNameKeyPath: "person",
																  cacheName: nil)
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}
}

