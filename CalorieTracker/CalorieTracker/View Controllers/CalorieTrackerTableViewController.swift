//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Percy Ngan on 12/20/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerTableViewController: UITableViewController {

	// MARK: - Properties & Outlets
	let calorieEntryController = CalorieEntryController()
	lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {

		let fetchedRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
		fetchedRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self as? NSFetchedResultsControllerDelegate
		try! frc.performFetch()
		return frc

	}()

	override func viewDidLoad() {
		super.viewDidLoad()


	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {

		return 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)



		return cell
	}

	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			tableView.deleteRows(at: [indexPath], with: .fade)

		}

		// MARK: Table View Data Source Delegate Methods
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
		/*
		// MARK: - Navigation

		// In a storyboard-based application, you will often want to do a little preparation before navigation
		override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		}
		*/

}
}
