import UIKit

final class MainTabBarController: UITabBarController {
  override var childForStatusBarStyle: UIViewController? {
    return selectedViewController
  }
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
