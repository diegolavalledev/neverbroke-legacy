import Foundation

public class NBStore {
  
  private static var url: URL {
    let manager = FileManager.default
    return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
  private static var categoryFile: URL {
    url.appendingPathComponent("CategoryData")
  }
  
  private static var transactionFile: URL {
    url.appendingPathComponent("TransactionData")
  }
  
  public static func persistAll() {
    try! NSKeyedArchiver.archivedData(withRootObject: NBCategory.budget, requiringSecureCoding: false).write(to: categoryFile)
    try! NSKeyedArchiver.archivedData(withRootObject: NBTransaction.all, requiringSecureCoding: false).write(to: transactionFile)
  }
  
  public static func populateAll() {
    NBCategory.populateAll(file: categoryFile)
    NBTransaction.populateAll(file: transactionFile)
  }
  public static func clearAllData() {
    if FileManager.default.fileExists(atPath: categoryFile.path) {
      try! FileManager.default.removeItem(atPath: categoryFile.path)
    }
    if FileManager.default.fileExists(atPath: transactionFile.path) {
      try! FileManager.default.removeItem(atPath: transactionFile.path)
    }
  }
}
