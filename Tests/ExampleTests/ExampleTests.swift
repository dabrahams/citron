@testable import expr
import XCTest

class ExprTests: XCTestCase {
  func testSuccess() {
    let tree = try? expr.parse("1 + 2 * 3 - 4")
    XCTAssertNotNil(tree)
  }
}
