import Foundation
import CoreData
import UIKit
import SafariServices

@available(iOS 14.0, *)

extension HomeTableViewController: NSFetchedResultsControllerDelegate {
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
  
  func openTwitter() {
    let twitterUrlWeb = URL(string: "https://www.twitter.com/NickNguyen_14")!
    let sf = SFSafariViewController(url: twitterUrlWeb)
    present(sf, animated: true, completion: nil)
  }
  
  func showErrorAlert(title: String,actionTitle: String) {
    let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: nil))
    present(ac, animated: true, completion: nil)
  }
}
