import UIKit

class ChartViewController: UIViewController, BarChartDataSource {
  func series(_ sender: BarChartView) -> [Double] {
    return [NBCategory.budgetTotal, NBTransaction.total]
  }
}
