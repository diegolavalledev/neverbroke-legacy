import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let clearData = UserDefaults.standard.bool(forKey: "clear_data_preference")
    if clearData {
      // clear
      NBStore.clearAllData()
      UserDefaults.standard.set(false, forKey: "clear_data_preference")
      UserDefaults.standard.synchronize()
    }
    NBStore.populateAll()
    return true
  }
}
