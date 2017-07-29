import XCTest
import Pavers

final class BooleanTests: XCTestCase {

  func testIsTrue() {
    XCTAssertTrue(isTrue(true))
    XCTAssertFalse(isTrue(false))
  }

  func testIsFalse() {
    XCTAssertTrue(isFalse(false))
    XCTAssertFalse(isFalse(true))
  }

  func testNegate() {
    XCTAssertTrue(negate(false))
    XCTAssertFalse(negate(true))
  }
}
