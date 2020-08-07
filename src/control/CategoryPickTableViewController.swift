import UIKit

class CategoryPickTableViewController: UITableViewController {
  
  var transaction: NBTransaction!
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    NBCategory.budget.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
    cell.category = NBCategory.budget[indexPath.row]
    if cell.category == transaction.category {
      cell.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
    transaction.category = cell.category
    navigationController?.popViewController(animated: true)
    return nil
  }
}
