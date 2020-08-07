import UIKit

class TransactionTableViewController: UITableViewController {
  
  // Model
  var transaction: NBTransaction? {
    didSet {
      configureView()
    }
  }
  
  @IBOutlet weak var descriptionLabel: UILabel? {
    didSet {
      configureView()
    }
  }
  
  @IBOutlet weak var categoryCell: UITableViewCell? {
    didSet {
      configureView()
    }
  }
  
  @IBOutlet weak var amountCell: UITableViewCell? {
    didSet {
      configureView()
    }
  }
  
  @IBOutlet weak var dateCell: UITableViewCell? {
    didSet {
      configureView()
    }
  }
  
  func configureView() {
    if let transaction = transaction {
      descriptionLabel?.text = transaction.summary
      categoryCell?.detailTextLabel?.text = transaction.category.name
      amountCell?.detailTextLabel?.text = String(transaction.amount)
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .short
      dateCell?.detailTextLabel?.text = formatter.string(from: transaction.date)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 && indexPath.row == 0 {
      return UITableView.automaticDimension
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    configureView()
  }
}
