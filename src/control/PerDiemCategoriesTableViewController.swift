import UIKit

class PerDiemCategoriesTableViewController: UITableViewController {
  
  @IBOutlet weak var perDiemLabel: UILabel!
  let categories = NBCategory.categoriesWithRemainingBudget
  
  override func viewDidLoad() {
    perDiemLabel.text = String(format: "%.1f", NBCategory.perDiem)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Share of per diem and remaining budged"
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Percentage represents the share of the per diem amount for each category and its remaining budget"
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    let category = categories[indexPath.row]
    // Configure the cell...
    cell.textLabel?.text = category.category.name
    let share = String(format: "%.1f", category.share * 100)
    let remaining = String(format: "%.1f", category.remaining)
    cell.detailTextLabel?.text = "\(share)% (\(remaining))"
    return cell
  }
}
