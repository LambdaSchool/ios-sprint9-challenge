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
		chartView.delegate = self
		let series = ChartSeries([1,2,3,4,5,6,])
		chartView.add(series)
		
		
		rightBarButtonItem()
//		addChartData()
	
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		caloriTrackerController.fetchTracks()
		
	}
	

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return caloriTrackerController.trackedCalories.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell()}
		
		 let tracked =  caloriTrackerController.trackedCalories[indexPath.row]
		cell.calorieLabel?.text = "Calories: \(tracked.caloriesCount!)"
			
		let formated = DateFormatter()
		formated.dateStyle = .full
//		formated.dateFormat = "yyyy-MM-dd  HH:mm a"
		let dateString = formated.string(from: tracked.date!)
			
		cell.dateLabel?.text = dateString
		
		return cell
	}
	
	private func rightBarButtonItem() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllCalories))
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
		
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	
	
	let caloriTrackerController = CalorieTrackerController()
	@IBOutlet var chartView: Chart!
}

extension CaloriesTableViewController {
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
		
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	func didEndTouchingChart(_ chart: Chart) {
		
	}
	
	
	func addChartData() {
		chartView = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		
		chartView = Chart()
		let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
//		series.color = ChartColors.greenColor()
		chartView.add(series)
		
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		chartView.setNeedsLayout()
	}
}
