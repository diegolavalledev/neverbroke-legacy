import UIKit

class TransactionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var descripcionLabel: UILabel!
  
  var transaction: NBTransaction! {
    didSet {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .short
      dateLabel.text = formatter.string(from: transaction.date)
      categoryLabel.text = transaction.category.name
      descripcionLabel.text = transaction.summary
      amountLabel.text = String(transaction.amount)
    }
  }
}
