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

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
		rightBarButtonItem()
//		fetchResultController.delegate = self
		chart.delegate = self
		
		//print(fetchResultController.fetchedObjects!.count)
		print(caloriTrackerController.fetchTracks().count)

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
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
	@IBOutlet var chart: Chart!
	
//	var fetchResultController: NSFetchedResultsController<Track> = {
//
//		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
//		fetchRequest.sortDescriptors =  []//[NSSortDescriptor(key: "date", ascending: true)]
//
//		let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//
//
//		do {
//			try fetchResultController.performFetch()
//		} catch {
//			NSLog("Error performing initial fetch: \(error)")
//		}
//
//
//		return fetchResultController
//	}()
	
	
}

extension CaloriesTableViewController: ChartDelegate {
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
		
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	func didEndTouchingChart(_ chart: Chart) {
		
	}
	
	
}
