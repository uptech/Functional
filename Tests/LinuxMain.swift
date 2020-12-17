import XCTest

import FunctionalTests

var tests = [XCTestCaseEntry]()
tests += FunctionalTests.allTests()
XCTMain(tests)
