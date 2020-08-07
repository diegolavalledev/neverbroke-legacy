import UIKit

class TransactionsTableViewController: UITableViewController, TransactionAddTableViewDelegate {
  
  var viewDidDisappear = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 162
    tableView.rowHeight = UITableView.automaticDimension
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem
  }
  
  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
    viewDidDisappear = false
    configureView()
  }
  
  func configureView() {
    tableView.reloadData()
    let tsvc = splitViewController as! TransactionsSplitViewController
    tsvc.hasEmptyDetails = tableView.indexPathForSelectedRow == nil
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewDidDisappear = true
  }
  
  @IBAction func refreshTable(_ sender: UIRefreshControl) {
    NBStore.populateAll()
    tableView.reloadData()
    sender.endRefreshing()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let headerView = tableView.tableHeaderView else {
      return
    }
    let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    if headerView.frame.size.height != size.height {
      headerView.frame.size.height = size.height
      tableView.tableHeaderView = headerView
      // This only seems to be necessary on iOS 9.
      tableView.layoutIfNeeded()
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if editing {
      let tsvc = splitViewController as! TransactionsSplitViewController
      tsvc.hasEmptyDetails = tableView.indexPathForSelectedRow == nil
    }
  }
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // return NBTransaction.recentCount > 0 ? 2 : 1
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return NBTransaction.recentCount
    case 1:
      return NBTransaction.all.count - NBTransaction.recentCount
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return NBTransaction.recentCount > 0 ? "Recently added" : nil
    case 1:
      return NBTransaction.all.count > 0
        ? NBTransaction.recentCount > 0 ? "Previous transactions" : "All transactions"
        : "No transactions found"
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 0:
      return NBTransaction.recentCount > 0 ? "Refresh (swipe down) to see recent transactions sorted and moved into the historical log below" : nil
    default:
      return nil
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
    cell.transaction = NBTransaction.all[(indexPath.section == 0 ? 0 : NBTransaction.recentCount) + indexPath.row]
    return cell
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
      cell.transaction.del()
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "TransactionAddSegue":
        let nc = segue.destination as! UINavigationController
        let tatvc = nc.topViewController as! TransactionAddTableViewController
        tatvc.delegate = self
      case "TransactionSegue":
        let tsvc = splitViewController as! TransactionsSplitViewController
        tsvc.hasEmptyDetails = false
        let cell = sender as! TransactionTableViewCell
        let nc = segue.destination as! UINavigationController
        nc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        nc.navigationItem.leftItemsSupplementBackButton = true
        let ttvc = nc.topViewController as! TransactionTableViewController
        ttvc.transaction = cell.transaction
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
