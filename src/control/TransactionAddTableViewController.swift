import UIKit

class TransactionAddTableViewController: UITableViewController {
  
  var delegate: TransactionAddTableViewDelegate?
  
  // Model
  var transaction = NBTransaction()
  
  @IBOutlet weak var descriptionCell: UITableViewCell!
  @IBOutlet weak var categoryCell: UITableViewCell!
  @IBOutlet weak var amountCell: UITableViewCell!
  @IBOutlet weak var dateCell: UITableViewCell!
  @IBOutlet weak var datePickerCell: UITableViewCell!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var amountStepper: UIStepper!
  @IBOutlet weak var transactionDateLabel: UILabel!
  @IBOutlet weak var transactionDatePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  private func doSelectRow(_ cell: UITableViewCell? = nil) {
    let indexPath = cell == nil ? IndexPath(row: 0, section: 0) : tableView.indexPath(for: cell!)!
    if let selectionIndexPath = tableView.indexPathForSelectedRow {
      if selectionIndexPath == indexPath {
        return
      }
      // if let deselectIndexPath = tableView(tableView, willDeselectRowAt: selectionIndexPath) {
      // }
      // else { we will never not allow deselection }
      tableView.deselectRow(at: selectionIndexPath, animated: false)
      tableView(tableView, didDeselectRowAt: selectionIndexPath)
    }
    if let nextIndexPath = tableView(tableView, willSelectRowAt: indexPath) {
      tableView.selectRow(at: nextIndexPath, animated: false, scrollPosition: .none)
      tableView(tableView, didSelectRowAt: nextIndexPath)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
    if tableView.indexPathForSelectedRow == nil {
      doSelectRow()
    }
  }
  
  @IBAction func descriptionTextFieldBegin(_ sender: UITextField) {
    doSelectRow(descriptionCell)
  }
  
  @IBAction func descriptionTextFieldReturned(_ sender: UITextField) {
    doSelectRow(amountCell)
  }
  
  @IBAction func amountTextFieldBegin(_ sender: UITextField) {
    doSelectRow(amountCell)
    if transaction.amount == 0 {
      sender.text = ""
    }
  }
  
  @IBAction func amountTextFieldEnd(_ sender: UITextField) {
    refresh()
  }
  
  @IBAction func amountTextFieldEditingChanged(_ sender: UITextField) {
    if sender.text!.isEmpty {
      return
    }
    if let amount = Double(sender.text!) {
      transaction.amount = amount
    }
    refresh()
  }
  @IBAction func changeAmount(_ sender: UIStepper) {
    doSelectRow(amountCell)
    transaction.amount = sender.value
    refresh()
  }
  
  @IBAction func selectDate(_ sender: UIDatePicker) {
    transaction.date = transactionDatePicker.date
    refresh()
  }
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func done(_ sender: UIBarButtonItem) {
    descriptionTextField.text! = descriptionTextField.text!.trimmingCharacters(in: .whitespaces)
    if descriptionTextField.text!.isEmpty {
      let alertController = UIAlertController(title: "Missing summary", message: "Please provide a non-empty summary for this transaction", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
        self?.doSelectRow()
      }
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    } else {
      transaction.summary = descriptionTextField.text!
      transaction.add()
      delegate?.transactionAddTableView(self, didCreateTransaction: transaction)
      dismiss(animated: true)
    }
  }
  
  func refresh() {
    categoryCell.detailTextLabel?.text = transaction.category.name
    amountTextField.text = String(Int(transaction.amount))
    amountStepper.value = transaction.amount
    transactionDatePicker.date = transaction.date
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    transactionDateLabel.text = formatter.string(from: transaction.date)
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if tableView.cellForRow(at: indexPath)! == datePickerCell {
      return nil
    }
    return indexPath
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch tableView.cellForRow(at: indexPath)! {
    case descriptionCell:
      descriptionTextField.becomeFirstResponder()
    case amountCell:
      amountTextField.becomeFirstResponder()
    case dateCell:
      datePickerCell.isHidden = false
    default: break
    }
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    switch tableView.cellForRow(at: indexPath) {
    case descriptionCell?:
      descriptionTextField.resignFirstResponder()
    case amountCell?:
      amountTextField.resignFirstResponder()
    case dateCell?:
      datePickerCell.isHidden = true
    default: break
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "CategorySelectSegue":
        if let vc = segue.destination as? CategoryPickTableViewController {
          vc.transaction = transaction
        }
      default: break
      }
    }
  }
}

protocol TransactionAddTableViewDelegate {
  func transactionAddTableView(_ transactionAddTableViewController: TransactionAddTableViewController, didCreateTransaction transaction: NBTransaction)
}
