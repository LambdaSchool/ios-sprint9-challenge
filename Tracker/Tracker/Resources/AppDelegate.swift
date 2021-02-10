import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().barTintColor = .link

  
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      
      UINavigationBar.appearance().tintColor = .white
      appearance.backgroundColor = .link
      appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white] //portrait title
      appearance.titleTextAttributes = [.foregroundColor : UIColor.white] //landscape title
      UINavigationBar.appearance().tintColor = .white
      UINavigationBar.appearance().standardAppearance = appearance //landscape
      UINavigationBar.appearance().compactAppearance = appearance
      UINavigationBar.appearance().scrollEdgeAppearance = appearance //portrait
    } else {
      UINavigationBar.appearance().isTranslucent = false
      UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

