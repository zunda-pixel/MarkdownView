import Algorithms
import Markdown
import XCTest

@testable import MarkdownUIParser

final class MarkdownUIParserTests: XCTestCase {
  func testExample() throws {
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest

    // Defining Test Cases and Test Methods
    // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
  }
  
  func testBlockQuoteKind() {
    for kind in Aside.Kind.allCases {
      let kind = BlockQuoteKind(rawValue: kind.rawValue)
      XCTAssertNotNil(kind)
    }
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
