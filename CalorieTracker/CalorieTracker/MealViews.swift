//
//  MealViews.swift
//  CalorieTracker
//
//  Created by William Bundy on 9/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftChart

let AllChartColors = [
	ChartColors.blueColor(),
	ChartColors.cyanColor(),
	ChartColors.darkRedColor(),
	ChartColors.darkGreenColor(),
	ChartColors.goldColor(),
	ChartColors.greenColor(),
	ChartColors.greyColor(),
	ChartColors.maroonColor(),
	ChartColors.orangeColor(),
	ChartColors.pinkColor(),
	ChartColors.purpleColor(),
	ChartColors.redColor(),
	ChartColors.yellowColor()]

class MealTVC: UITableViewController, NSFetchedResultsControllerDelegate
{
	var person = "Anonymous"

	var controller = MealController.shared
	lazy var dateFormatter:DateFormatter = {
		let local = DateFormatter()
		local.dateFormat = "MM/dd HH:mm"
		return local
	}()

	@IBOutlet weak var chart: Chart!

	lazy var fetcher:NSFetchedResultsController<Meal> = {
		let moc = CoreDataStack.shared.mainContext
		var req:NSFetchRequest<Meal> = Meal.fetchRequest()
		req.sortDescriptors = [
			NSSortDescriptor(key:"person", ascending:false),
			NSSortDescriptor(key:"timestamp", ascending:true),
		]

		var local =  NSFetchedResultsController(
			fetchRequest: req,
			managedObjectContext: moc,
			sectionNameKeyPath: "person",
			cacheName: nil)

		// shouldn't crash
		try! local.performFetch()
		local.delegate = self

		return  local
	}()

	@IBAction func addMeal(_ sender: Any) {
		let alert = UIAlertController(title: "New Meal", message: "Enter Calories", preferredStyle: .alert)

		var calorieField:UITextField!
		alert.addTextField {
			local in
			calorieField = local
			local.placeholder = "Calories"
			local.keyboardType = .numberPad
		}

		var nameField:UITextField!
		alert.addTextField {
			local in
			nameField = local
			local.text = self.person
		}


		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })

		alert.addAction(UIAlertAction(title: "Add", style: .default) {
			action in

			guard let text = calorieField.text else { return }
			guard let newPerson = nameField.text else { return}
			guard let amount = Int(text) else { return }
			self.controller.create(amount, newPerson)
			self.person = newPerson
			UserDefaults.standard.set(self.person, forKey: "com.wb.PersonName")
		})

		self.present(alert, animated: true) {
			NSLog("Alerted!")
		}
	}


	override func viewDidLoad() {
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(onMealChanged(_:)), name: MealChanged, object: nil)

		person = UserDefaults.standard.string(forKey: "com.wb.PersonName") ?? "Anonymous"

		controller.loadMeals()
		rebuildChart()
	}

	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

	@objc func onMealChanged(_ notification:NSNotification)
	{
		rebuildChart()
	}

	func rebuildChart()
	{
		chart.removeAllSeries()
		var allSeries:[ChartSeries] = []
		for (person, meals) in controller.meals {
			let series = ChartSeries(meals.map({Double($0.calories)}))
			series.color = AllChartColors[person.hashValue % AllChartColors.count]
			series.area = true
			allSeries.append(series)
		}
		chart.add(allSeries)
	}

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
		tableView.beginUpdates()
	}

	func controller(
    		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
    		didChange sectionInfo: NSFetchedResultsSectionInfo,
    		atSectionIndex sectionIndex: Int,
    		for type: NSFetchedResultsChangeType)
	{
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer:sectionIndex), with: .automatic)
		case .delete:
			tableView.deleteSections(IndexSet(integer:sectionIndex), with: .automatic)
		default:
			break
		}
	}

	func controller(
			_ controller: NSFetchedResultsController<NSFetchRequestResult>,
			didChange anObject: Any,
			at indexPath: IndexPath?,
			for type: NSFetchedResultsChangeType,
			newIndexPath: IndexPath?)
	{
		switch type {
		case .insert:
			guard let path = newIndexPath else {return}
			tableView.insertRows(at: [path], with: .automatic)
		case .delete:
			guard let path = indexPath else {return}
			tableView.deleteRows(at: [path], with: .automatic)
		case .update:
			guard let path = indexPath else {return}
			tableView.reloadRows(at: [path], with: .automatic)
		case .move:
			guard let path = indexPath, let newPath = newIndexPath else {return}
			tableView.deleteRows(at: [path], with: .automatic)
			tableView.insertRows(at: [newPath], with: .automatic)
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return fetcher.sections![section].numberOfObjects
	}

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return fetcher.sections!.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetcher.sections![section].name
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
		let meal = fetcher.object(at: indexPath)
		defaultCell.textLabel?.text = "\(meal.calories) \t\t \(dateFormatter.string(from: meal.timestamp ?? Date()))"
		return defaultCell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			controller.delete(fetcher.object(at: indexPath))
		}
	}
}
