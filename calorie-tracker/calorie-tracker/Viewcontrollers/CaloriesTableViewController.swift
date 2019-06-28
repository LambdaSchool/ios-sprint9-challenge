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
		chart.delegate = self
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultController.fetchedObjects?.count ?? 0
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell()}
		
		cell.calorieLabel?.text = "\(indexPath.row)"
		return cell
	}
	
	private func rightBarButtonItem() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalorie))
	}
	
	// MARK: get Calories
	@objc func addCalorie() {
		let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of Calories in the field", preferredStyle: .alert)
		alertController.addTextField()
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		
		let submit = UIAlertAction(title: "Submit", style: .default, handler: { _ in
			let str = alertController.textFields?[0].text
			
			
			
			print(str!)
		})
		
		[cancel, submit].forEach { alertController.addAction($0) }
		
		present(alertController, animated:  true)
	}
	
	let caloriTrackerController = CalorieTrackerController()
	@IBOutlet var chart: Chart!
	
	lazy var fetchResultController: NSFetchedResultsController<Track> = {
		
		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		
		let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchResultController.delegate = self
		
		do {
			try fetchResultController.performFetch()
		} catch {
			NSLog("Error performing initial fetch: \(error)")
		}
		
		
		return fetchResultController
	}()
	
}

extension CaloriesTableViewController: ChartDelegate {
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
		
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	func didEndTouchingChart(_ chart: Chart) {
		
	}
	
	
}
