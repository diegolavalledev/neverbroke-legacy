import Foundation

public class NBTransaction: NSObject, NSCoding /*, CustomStringConvertible */ {

    public required init?(coder aDecoder: NSCoder) {
        summary = aDecoder.decodeObject(forKey: "summary")! as! String
        amount = aDecoder.decodeDouble(forKey: "amount")
        date = aDecoder.decodeObject(forKey: "date")! as! Date
        let categoryId = aDecoder.decodeObject(forKey: "categoryId")! as! String
        category = NBCategory.budget.first(where: {$0.id == categoryId})!
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(summary, forKey: "summary")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(category.id, forKey: "categoryId")
    }
    
    public static func populateAll(file: URL) {
      if let all = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: file)) as? [NBTransaction] {
            // We sort when we load so we can keep track of the transactions added during the session
            NBTransaction.all = all.sorted() { $0.date > $1.date }
            recentCount = 0
        }
    }

    public static var all:[NBTransaction] = []
    public static var recentCount = 0

    public static var total: Double {
        return all.reduce(0) { $0 + $1.amount }
    }

    private static var daysTransactions: [NBTransaction] {
        return all.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .day)
        }
    }
    
    private static var monthsTransactions: [NBTransaction] {
        return all.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
    }
    
    public static var dayTotal: Double {
        return sumAmount(daysTransactions)
    }
    
    public static var monthTotal: Double {
        return sumAmount(monthsTransactions)
    }
    
    public var summary = ""
    public var amount = 0.0
    public var date = Date()
    public var category = NBCategory.other

    override public var description: String {
        return "(\(summary), \(amount))"
    }

    public override init() {
        super.init()
    }

    public func add() {
        NBTransaction.all.insert(self, at: 0)
        NBTransaction.recentCount += 1
        NBStore.persistAll()
    }

    public func del() {
      if let i = NBTransaction.all.firstIndex(of: self) {
            NBTransaction.all.remove(at: i)
            if i < NBTransaction.recentCount {
                NBTransaction.recentCount -= 1
            }

        }
        NBStore.persistAll()
    }

    private static func sumAmount(_ transactions: [NBTransaction]) -> Double {
        return transactions.reduce(0) { $0 + $1.amount }
    }

    public static func monthTotal(forCategory category: NBCategory) -> Double {
        return sumAmount(monthsTransactions.filter {
            $0.category == category
        })
    }
}
