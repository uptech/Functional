import XCTest
@testable import Functional

final class FunctionalTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Functional().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
