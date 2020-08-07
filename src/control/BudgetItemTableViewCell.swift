import UIKit

class BudgetItemTableViewCell: UITableViewCell, UITextViewDelegate {
  
  var category: NBCategory! {
    didSet {
      if let category = self.category {
        descriptionTextView.text = category.name
        refresh()
        if category.isLocked {
          descriptionTextView.isEditable = false
        }
      }
    }
  }
  
  @IBOutlet weak var descriptionTextView: UITextView! {
    didSet {
      descriptionTextView.delegate = self
    }
  }
  
  @IBOutlet weak var amountTextField: UITextField!
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    //Place your code here...
    contentView.isUserInteractionEnabled = editing
    //updateCellHeight()
  }
  
  // MARK: - UITextViewDelegate
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView == descriptionTextView {
      let lines = textView.text!.components(separatedBy: .newlines)
      textView.text = lines.joined(separator: " ").trimmingCharacters(in: .whitespaces)
      category?.name = textView.text
      updateCellHeight()
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    if textView == descriptionTextView {
      let lines = textView.text!.components(separatedBy: .newlines)
      if lines.count > 1 {
        amountTextField.becomeFirstResponder()
      } else {
        updateCellHeight()
      }
    }
  }
  
  @IBAction func amountTextFieldBegin(_ sender: UITextField) {
    if category.budgetAmount == 0 {
      sender.text = ""
    }
  }
  
  @IBAction func amountTextFieldEditingChanged(_ sender: UITextField) {
    if sender.text!.isEmpty {
      return
    }
    if let amount = Double(sender.text!) {
      category.budgetAmount = amount
    }
    refresh()
  }
  
  @IBAction func amountTextFieldReturned(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  
  @IBAction func amountTextFieldEnd(_ sender: UITextField) {
    if sender.text!.isEmpty {
      category.budgetAmount = 0
    }
    refresh()
  }
  
  func refresh() {
    amountTextField.text =  String(Int(category.budgetAmount))
  }
  
  private func updateCellHeight() {
    let size = descriptionTextView.bounds.size
    let newSize = descriptionTextView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
    // Resize the cell only when cell's size is changed
    if size.height != newSize.height {
      UIView.setAnimationsEnabled(false)
      tableView?.beginUpdates()
      tableView?.endUpdates()
      UIView.setAnimationsEnabled(true)
      if let thisIndexPath = tableView?.indexPath(for: self) {
        tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
      }
    }
  }
}

// The tableview is accessed inside the cell by an extension:

extension UITableViewCell {
  /// Search up the view hierarchy of the table view cell to find the containing table view
  var tableView: UITableView? {
    get {
      var table: UIView? = superview
      while !(table is UITableView) && table != nil {
        table = table?.superview
      }
      return table as? UITableView
    }
  }
}
