import UIKit

class SpendDataTableViewController: UITableViewController, TransactionAddTableViewDelegate {
  
  
  @IBOutlet weak var monthlyBudgetCell: UITableViewCell!
  @IBOutlet weak var remainingLabel: UILabel!
  @IBOutlet weak var spentLabel: UILabel!
  @IBOutlet weak var totalBudgetLabel: UILabel!
  @IBOutlet weak var perDiemLabel: UILabel!
  @IBOutlet weak var daysSpendLabel: UILabel!
  @IBOutlet weak var daysLeftLabel: UILabel!
  
  var viewDidDisappear = true
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewDidDisappear = false
    configureView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewDidDisappear = true
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath == tableView.indexPath(for: monthlyBudgetCell)! {
      if let tabBarController = navigationController?.tabBarController {
        tabBarController.selectedIndex = 1
      }
    }
  }
  
  func configureView() {
    remainingLabel.text = String(Int(NBCategory.remaining.rounded()))
    spentLabel.text = String(Int(NBCategory.spent))
    totalBudgetLabel.text = String(Int(NBCategory.budgetTotal))
    perDiemLabel.text = String(format: "%.1f", NBCategory.perDiem)
    daysSpendLabel.text = String(Int(NBTransaction.dayTotal))
    daysLeftLabel.text = String(Calendar.current.daysRemainingInCurrentMonth)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "TransactionAddSegue":
        let nc = segue.destination as! UINavigationController
        let tatvc = nc.topViewController as! TransactionAddTableViewController
        tatvc.delegate = self
      default: break
      }
    }
  }
  
  func transactionAddTableView(_ transactionAddTableViewController: TransactionAddTableViewController, didCreateTransaction transaction: NBTransaction) {
    transactionAddTableViewController.delegate = nil
    if !viewDidDisappear {
      configureView()
    }
  }
}
