//
//  CalorieEntryTableVC.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreData

class CalorieEntryTableVC: UITableViewController {
   
   var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .short
      return formatter
   }
   
   lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
      let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
      fetchRequest.sortDescriptors = [
         NSSortDescriptor(key: "date", ascending: false)
      ]
      let frc = NSFetchedResultsController(
         fetchRequest: fetchRequest,
         managedObjectContext: CoreDataStack.shared.mainContext,
         sectionNameKeyPath: nil,
         cacheName: nil
      )
      frc.delegate = self
      do {
         try frc.performFetch()
      } catch {
         print(error)
      }
      return frc
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: .newCalorieEntryAdded, object: nil)
   }
   
   // MARK: - Public
   
   @objc func scrollToTop() {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
   }
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      fetchedResultsController.sections?[section].numberOfObjects ?? 0
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)
      
      let calorieEntry = fetchedResultsController.object(at: indexPath)
      guard let date = calorieEntry.date else { fatalError("no date") }
      
      cell.textLabel?.text = "Calories: \(calorieEntry.calories)"
      cell.detailTextLabel?.text = dateFormatter.string(from: date)
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         let calorieEntry = fetchedResultsController.object(at: indexPath)
         let context = CoreDataStack.shared.mainContext
         context.delete(calorieEntry)
         do {
            try context.save()
         } catch {
            NSLog("Error saving context after deleting Task: \(error)")
            context.reset()
         }
      }
   }
}

extension CalorieEntryTableVC: NSFetchedResultsControllerDelegate {
   
   func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
   }
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
   }
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange sectionInfo: NSFetchedResultsSectionInfo,
                   atSectionIndex sectionIndex: Int,
                   for type: NSFetchedResultsChangeType) {
      switch type {
      case .insert:
         tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
      case .delete:
         tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
      default:
         break
      }
   }
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
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
         break
      }
   }
}
