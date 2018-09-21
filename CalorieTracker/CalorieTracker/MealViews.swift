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

class MealTVC: UITableViewController, NSFetchedResultsControllerDelegate
{
	let person = "Anonymous Coward"

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

		var textField:UITextField!
		alert.addTextField {
			local in
			textField = local
			local.placeholder = "Calories"
			local.keyboardType = .numberPad
		}

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
			action in
			alert.dismiss(animated: true) {

			}
		})

		alert.addAction(UIAlertAction(title: "Add", style: .default) {
			action in

			guard let text = textField.text else { return }
			guard let amount = Int(text) else { return }
			self.controller.create(amount,  self.person)
		})

		self.present(alert, animated: true) {
			NSLog("Alerted!")
		}
	}


	override func viewDidLoad() {
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(onMealChanged(_:)), name: MealChanged, object: nil)

		controller.loadMeals()
		rebuildChart()
	}

	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

	@objc func onMealChanged(_ notification:NSNotification)
	{
		guard let meals = notification.object as? [MealStub] else {
			NSLog("Got MealChanged notification, but no object!")
			return
		}

		rebuildChart()
	}

	func rebuildChart()
	{
		chart.removeAllSeries()
		for meals in controller.meals.values {
			chart.add(ChartSeries(meals.map({Double($0.calories)})))
		}
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

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
		let meal = fetcher.object(at: indexPath)
		defaultCell.textLabel?.text = "\(meal.calories) \(dateFormatter.string(from: meal.timestamp ?? Date()))"
		return defaultCell
	}
}
