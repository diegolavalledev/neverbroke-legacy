import UIKit

class CategoryTableViewCell: UITableViewCell {
  var category: NBCategory! {
    didSet {
      textLabel?.text = category.name
    }
  }
}
