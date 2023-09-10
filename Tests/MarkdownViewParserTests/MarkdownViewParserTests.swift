import Algorithms
import Markdown
import XCTest

@testable import MarkdownViewParser

final class MarkdownViewParserTests: XCTestCase {
  func testExample() throws {
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest

    // Defining Test Cases and Test Methods
    // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
  }
  
  func testFileExtensionNameParse() {
    let content = "swift: Sample.swift "
    let elements = content.split(separator: ":", maxSplits: 1)
    let fileExtension = elements[0]
    let fileName = elements[1]
    
    XCTAssertEqual(fileExtension, "swift")
    XCTAssertEqual(fileName.trimming(while: \.isWhitespace), "Sample.swift")
  }
}
