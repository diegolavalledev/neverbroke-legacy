import Foundation

public class NBCategory: NSObject, /*Equatable, Hashable, CustomStringConvertible,*/ NSCoding {

    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name")! as! String
        budgetAmount = aDecoder.decodeDouble(forKey: "budgetAmount")
        isLocked = aDecoder.decodeBool(forKey: "isLocked")
        position = aDecoder.decodeObject(forKey: "position") as? Int
        id = aDecoder.decodeObject(forKey: "id")! as! String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(budgetAmount, forKey: "budgetAmount")
        aCoder.encode(isLocked, forKey: "isLocked")
        aCoder.encode(position, forKey: "position")
        aCoder.encode(id, forKey: "id")
    }

    public static func populateAll(file: URL) {
      if let budget = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: file)) as? [NBCategory] {
            if let otherCategory = budget.first(where: {$0.isLocked}) {
                NBCategory.other = otherCategory
                NBCategory.budget = budget
            }
        }
    }

    public typealias Stats = (budget: Double, spent: Double, spentShare: Double, remaining: Double)

    private static let NAME_NEW = "New Category"
    public static var other = NBCategory(name: "Other", isLocked: true)

    public static var budget = [other]

    public static var budgetTotal: Double {
        return budget.reduce(0) { $0 + $1.budgetAmount }
    }

    public static var spent: Double {
        return NBTransaction.monthTotal
    }

    public static var remaining: Double {
        return budgetTotal - spent
    }

    public static var statsByCategory: [NBCategory:Stats] {
        var stats: [NBCategory:Stats] = [:]
        for category in budget {
            stats[category] = category.stats
        }
        return stats
    }

    public static var perDiem: Double {
        return remaining / Double(Calendar.current.daysRemainingInCurrentMonth)
    }

    public static var categoriesWithRemainingBudget: [(category: NBCategory, remaining: Double, share: Double)] {
        return budget.filter {
            $0.remaining > 0
        }.map {
            (category: $0, remaining: $0.remaining, share: $0.remaining / NBCategory.remaining)
        }.sorted {
            $0.remaining > $1.remaining
        }
    }

    public static func == (lhs: NBCategory, rhs: NBCategory) -> Bool {
        return lhs.id == rhs.id
    }

    public static func addNew() -> NBCategory {
        let category = NBCategory(name: NAME_NEW)
        budget.insert(category, at: 0)
        category.position = budget.count
        return category
    }

    private static func recalcPositions() {
        for (i, category) in budget.enumerated() {
            category.position = budget.count - i
        }
    }
    
    public var id = UUID().uuidString
    public var name = ""
    public var budgetAmount = 0.0
    public var isLocked = false // Cant edit name
    public var position: Int?

    override public var description: String {
        return "(\(name), \(budgetAmount))"
    }

    override public var hash: Int {
        return id.hashValue
    }
    
    public var spent: Double {
        return NBTransaction.monthTotal(forCategory: self)
    }
    
    public var remaining: Double {
        return budgetAmount - spent
    }
    
    public var stats: Stats {
        let spentTotal = NBTransaction.monthTotal
        return (
            budget: budgetAmount,
            spent: spent,
            spentShare: spentTotal == 0 ? 0 : spent / spentTotal,
            remaining: remaining
        )
    }
    
    public init(name: String) {
        self.name = name
    }
    
    public convenience init(name: String, isLocked: Bool) {
        self.init(name: name)
        self.isLocked = isLocked
    }

    public func del() {
        for t in NBTransaction.all {
            if t.category == self {
                t.category = NBCategory.other
            }
        }
      if let i = NBCategory.budget.firstIndex(of: self) {
            NBCategory.budget.remove(at: i)
        }
    }

    public func move(toPosition: Int) {
      if let i = NBCategory.budget.firstIndex(of: self) {
            NBCategory.budget.remove(at: i)
            NBCategory.budget.insert(self, at: toPosition)
            NBCategory.recalcPositions()
        }
    }
}

extension Calendar {

    public var daysPastInCurrentMonth: Int {
        let justNow = Date()
        let startOfMonth = self.date(from: self.dateComponents([.year, .month], from: justNow))!
        let daysBetween = self.dateComponents([.day], from: startOfMonth, to: justNow).day!
        return daysBetween + 1
    }

    public var daysRemainingInCurrentMonth: Int {
        let justNow = Date()
        // Calculate start and end of the current month
        let interval = self.dateInterval(of: .month, for: justNow)!
        // Compute difference in days
        let totalDays = self.dateComponents([.day], from: justNow, to: interval.end).day!
        return totalDays + 1
    }
}
