//
//  TrackerVC.swift
//  CalorieTracker
//
//  Created by Jeffrey Santana on 9/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class TrackerVC: UIViewController {

	//MARK: - IBOutlets
	
	@IBOutlet weak var graphView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Properties
	
	lazy var fetchResultsController: NSFetchedResultsController<Intake> = {
		let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
		
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false),
										NSSortDescriptor(key: "calories", ascending: true)]
		
		let fetchControl = NSFetchedResultsController(fetchRequest: fetchRequest,
													  managedObjectContext: CoreDataStack.shared.mainContext,
													  sectionNameKeyPath: "timestamp",
													  cacheName: nil)
		
		fetchControl.delegate = self
		
		do {
			try fetchControl.performFetch()
		} catch {
			fatalError("Error performing fetch for fetchControl: \(error)")
		}
		
		return fetchControl
	}()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	//MARK: - IBActions
	
	@IBAction func addIntakeBtnTapped(_ sender: Any) {
	}
	
	//MARK: - Helpers
	
	
}

extension TrackerVC:  NSFetchedResultsControllerDelegate {
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
			fatalError()
		}
	}
	
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
