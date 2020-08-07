import UIKit

class BudgetTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 144
    tableView.rowHeight = UITableView.automaticDimension
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isEditing {
      setEditing(false, animated: false)
    }
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
    }
  }
  
  @IBAction func addBudgetItem(_ sender: UIBarButtonItem) {
    let _ = NBCategory.addNew()
    let topIndexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [topIndexPath], with: .automatic)
    if !isEditing {
      self.setEditing(true, animated: true)
    }
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    // clearTableViewSelection()
    super.setEditing(editing, animated: animated)
    if !editing {
      NBStore.persistAll()
      // tableView.reloadData()
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return NBCategory.budget.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetItemCell", for: indexPath) as! BudgetItemTableViewCell
    cell.category = NBCategory.budget[indexPath.row]
    return cell
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      NBCategory.budget[indexPath.row].del()
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    NBCategory.budget[fromIndexPath.row].move(toPosition: to.row)
  }
  
  override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
    if NBCategory.budget[proposedDestinationIndexPath.row].isLocked {
      // Only one category is locked (Other)
      return IndexPath(row: proposedDestinationIndexPath.row - 1, section: proposedDestinationIndexPath.section)
    } else {
      return proposedDestinationIndexPath
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return NBCategory.budget[indexPath.row].isLocked ? .none : .delete
  }
  
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return !NBCategory.budget[indexPath.row].isLocked
  }
}
