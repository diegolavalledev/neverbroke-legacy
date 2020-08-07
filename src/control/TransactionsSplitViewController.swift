import UIKit

class TransactionsSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
  
  var hasEmptyDetails = true {
    didSet {
      if oldValue != hasEmptyDetails && viewControllers.count > 1 {
        let newDetailViewController = storyboard!.instantiateViewController(withIdentifier: hasEmptyDetails ? "EmptyDetail" : "TransactionDetail") as! UINavigationController
        newDetailViewController.topViewController!.navigationItem.leftBarButtonItem = displayModeButtonItem
        viewControllers[1] = newDetailViewController
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    delegate = self
  }
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
    guard let topAsDetailController = secondaryAsNavController.topViewController as? TransactionTableViewController else { return false }
    if topAsDetailController.transaction == nil {
      // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
      return true
    }
    return false
  }
}
