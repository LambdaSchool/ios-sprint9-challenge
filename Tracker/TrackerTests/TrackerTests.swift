import XCTest
@testable import Tracker

class TrackerTests: XCTestCase {
  
  let calories = CalorieController()
  
  func testCreateItem() {
    calories.createNewItem(amount: 200)
    XCTAssertTrue(calories.calrories.count != 0)
  }
  func testDelete() {
    let cal = Calorie(context: CoreDataStack.shared.mainContext)
    cal.amount = 200
    cal.date = Date()
    calories.deleteItem(calorie: cal)
    XCTAssertTrue(calories.calrories.count == 0)
  }
}
