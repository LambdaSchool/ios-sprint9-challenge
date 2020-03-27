//
//  CalroiesMainTableViewController + Ext.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension CalroriesMainTableViewController: NSFetchedResultsControllerDelegate {
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
                 break
             
         }
     }
}
