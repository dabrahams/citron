import XCTest
@testable import executable

final class Tests: XCTestCase {

  func test() {
    XCTAssertEqual(audience(), "world!")
  }

}
