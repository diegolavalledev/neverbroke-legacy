import UIKit
import NeverbrokeModel

NBCategory.other.budgetAmount = 200

let housing = NBCategory.addNew()
housing.name = "Housing"
housing.budgetAmount = 400

let misc = NBCategory.addNew()
misc.name = "Misc"
misc.budgetAmount = 100

let food = NBCategory.addNew()
food.name = "Food"
food.budgetAmount = 100

NBCategory.budgetTotal
NBCategory.budgetTotal

let rent = NBTransaction()
rent.summary = "Rent"
rent.amount = 350
rent.category = housing
rent.add()

let lunch = NBTransaction()
lunch.summary = "Lunch"
lunch.amount = 50
lunch.category = food
lunch.add()

let dinner = NBTransaction()
dinner.summary = "Dinner"
dinner.amount = 50
dinner.category = food
dinner.add()

let supplies = NBTransaction()
supplies.summary = "Supplies"
supplies.amount = 50
supplies.category = misc
supplies.add()

let tools = NBTransaction()
tools.summary = "Tools"
tools.amount = 200
// supplies.category = NBCategory.OTHER
tools.add()

var total = NBTransaction.total
NBCategory.statsByCategory

supplies.category// Misc
misc.del()
assert(supplies.category == NBCategory.other) // Other

supplies.del()

Calendar.current.daysPastInCurrentMonth
Calendar.current.daysRemainingInCurrentMonth

NBCategory.remaining
NBCategory.perDiem
NBCategory.categoriesWithRemainingBudget
