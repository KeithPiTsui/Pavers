import XCTest
@testable import Pavers

final class UnitTests: XCTestCase {

  func testUnitEquality() {
    XCTAssertEqual(Pavers.Unit(), Pavers.Unit())
  }
}
