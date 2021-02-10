import UIKit
import StoreKit

class SettingTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 1 {
      SKStoreReviewController.requestReview()
    } else if indexPath.row == 0 {
      sendEmail()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
