//
//  CaloriesTableViewController.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ChartDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
		barButtonItems()
		NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .caloriesAdded, object: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		caloriTrackerController.fetchTracks()
		addChartData()

		
	}
	

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return caloriTrackerController.trackedCalories.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }
		let tracked =  caloriTrackerController.trackedCalories[indexPath.row]
		cell.calorieLabel?.text = "Calories: \(tracked.caloriesCount!)"
			
		let formated = DateFormatter()
		formated.dateFormat = "MMM dd, yyyy 'at' HH:mm a"
		let dateString = formated.string(from: tracked.date!)
			
		cell.dateLabel?.text = dateString
		
		return cell
	}
	
	private func barButtonItems() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
		
		// MARK: Remove only for testing
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllCalories))
	}

	@objc func refresh() {
		self.tableView.reloadData()
		self.addChartData()
	}
	
	@objc func addCalorie() {
		let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of Calories in the field", preferredStyle: .alert)
		alertController.addTextField()
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		
		let submit = UIAlertAction(title: "Submit", style: .default, handler: { [unowned alertController] _ in
			if let caloriesCount = alertController.textFields?[0].text {
				DispatchQueue.main.async {
					self.submitCalories(caloriesCount)
				}
			}
		})
		
		[cancel, submit].forEach { alertController.addAction($0) }
		present(alertController, animated:  true)
	}
	
	
	@objc func deleteAllCalories() {
		caloriTrackerController.deleteAll()
		chartView.add([])
		NotificationCenter.default.post(name: .caloriesAdded, object: nil)
	}
	
	private func submitCalories(_ caloriesCount: String) {
		guard let _ = Int(caloriesCount) else {
			//send error
			return
		}
		
		CoreDataStack.shared.mainContext.performAndWait {
			let track = Track(caloriesCount: caloriesCount)
			try? caloriTrackerController.save(track)
		}
		
		NotificationCenter.default.post(name: .caloriesAdded, object: nil)
	}
	
	
	
	let caloriTrackerController = CalorieTrackerController()
	@IBOutlet var chartView: Chart! {
		didSet {
			addChartData()
		}
	}
}

extension CaloriesTableViewController {
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
	}
	
	func didEndTouchingChart(_ chart: Chart) {
	}
	
	
	func addChartData() {
		chartView.delegate = self
		chartView.xLabels = caloriTrackerController.getXLabels
		chartView.yLabels = caloriTrackerController.getYLabels
		let series = ChartSeries(data: caloriTrackerController.getData)
		series.area = true
		chartView.removeAllSeries()
		chartView.add(series)
	}

}
