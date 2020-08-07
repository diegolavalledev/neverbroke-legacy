import UIKit

class SpendCategoriesTableViewController: UITableViewController {
  
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
      // tableView.layoutIfNeeded()
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return NBCategory.budget.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    let category = NBCategory.budget[indexPath.row]
    let stats = category.stats
    // Configure the cell...
    cell.textLabel?.text = category.name
    let spent = String(format: "%.1f", stats.spent)
    let budget = String(format: "%.1f", stats.budget)
    let share = String(format: "%.1f", stats.spentShare * 100)
    cell.detailTextLabel?.text = "\(spent) of \(budget) (\(share)%)"
    return cell
  }
}
