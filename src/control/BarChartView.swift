import UIKit

protocol BarChartDataSource: class {
  func series(_ sender: BarChartView) -> [Double]
}

@IBDesignable
class BarChartView: UIView {
  @IBInspectable
  var lineWidth:CGFloat = 3 { didSet { setNeedsDisplay() } }
  @IBInspectable
  var fillColorA: UIColor = UIColor.yellow { didSet { setNeedsDisplay() } }
  @IBInspectable
  var fillColorB: UIColor = UIColor.orange { didSet { setNeedsDisplay() } }
  @IBInspectable
  var strokeColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
  
  var budgetLabel: UILabel? {
    didSet {
      if oldValue !== nil {
        oldValue?.removeFromSuperview()
      }
      addSubview(budgetLabel!)
    }
  }
  
  var spentLabel: UILabel? {
    didSet {
      if oldValue !== nil {
        oldValue?.removeFromSuperview()
      }
      addSubview(spentLabel!)
    }
  }
  
  static let totalBars: CGFloat = 2
  
  @IBOutlet open weak var dataSource: AnyObject!
  
  private func barPath(offset: CGFloat = 0.0, percentage: CGFloat = 0.0) -> UIBezierPath {
    
    let barMaxHeight = bounds.size.height * 0.8
    
    let barWidth = bounds.size.width * 0.2
    
    let barHeight = percentage * barMaxHeight
    
    let barBoundWidth = bounds.size.width * 0.9 / BarChartView.totalBars
    let barOriginX = (bounds.size.width * 0.05) + offset * barBoundWidth + barBoundWidth / 2 - barWidth / 2
    let barOriginY = (bounds.size.height * 0.1) + (barMaxHeight - (percentage * barMaxHeight))
    let boxOrigin = CGPoint(x: barOriginX, y: barOriginY)
    let boxSize = CGSize(width: barWidth, height: barHeight)
    let path = UIBezierPath(rect: CGRect(origin: boxOrigin, size: boxSize))
    return path
  }
  
  private func createLabelFor(_ text: String, withOffset offset: CGFloat = 0.0) -> UILabel {
    let label = UILabel(frame: frameForLabelWithOffset(offset))
    label.textAlignment = .center
    label.text = text
    return label
  }
  
  private func frameForLabelWithOffset(_ offset: CGFloat = 0.0) -> CGRect {
    let barWidth = bounds.size.width * 0.4
    let barHeight = bounds.size.height * 0.1
    let barBoundWidth = bounds.size.width * 0.9 / BarChartView.totalBars
    let barOriginX = (bounds.size.width * 0.05) + offset * barBoundWidth + barBoundWidth / 2 - barWidth / 2
    let barOriginY = bounds.size.height * 0.9
    let boxOrigin = CGPoint(x: barOriginX, y: barOriginY)
    let boxSize = CGSize(width: barWidth, height: barHeight)
    let frame = CGRect(origin: boxOrigin, size: boxSize)
    return frame
  }
  
  override func draw(_ rect: CGRect) {
    // Drawing code
    var series: [Double]
    if let dataSource = self.dataSource as? BarChartDataSource {
      series = dataSource.series(self)
    } else {
      series = [50, 200]
    }
    
    let max = series.max()!
    let percentages = series.map() { $0 / max }
    
    let barPathA = barPath(offset: 0, percentage: CGFloat(percentages[0]))
    fillColorA.setFill()
    barPathA.fill()
    
    let barPathB = barPath(offset: 1, percentage: CGFloat(percentages[1]))
    fillColorB.setFill()
    barPathB.fill()
    
    budgetLabel = createLabelFor("Budget")
    spentLabel = createLabelFor("Total spent", withOffset: 1)
  }
}
