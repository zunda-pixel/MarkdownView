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

func printMarkup(markup: Markup, depth: Int) {
  print(String(repeating: "\t", count: depth * 2), type(of: markup))
  for child in markup.children {
    printMarkup(markup: child, depth: depth + 1)
  }
}

func printInlineMarkupContent(content: InlineMarkupContent, depth: Int) {
  switch content {
  case .image(title: let title, source: let source):
    print("\(String(repeating: "\t", count: depth * 2))Image \(title) \(source ?? "")")
  case .text(text: let text):
    print("\(String(repeating: "\t", count: depth * 2))Text \(text)")
  case .lineBreak:
    print("\(String(repeating: "\t", count: depth * 2))LineBreak")
  case .softBreak:
    print("\(String(repeating: "\t", count: depth * 2))SoftBreak")
  case .link(destination: let destination, children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Link \(destination ?? "")")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strong(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Strong")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strikethrough(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .emphasis(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .inlineCode(code: let code):
    print("\(String(repeating: "\t", count: depth * 2))InlineCode \(code)")
  case .inlineHTML(html: let html):
    print("\(String(repeating: "\t", count: depth * 2))InlineHTML \(html)")
  case .symbolLink(destination: let destination):
    print("\(String(repeating: "\t", count: depth * 2))SymbolLink \(destination ?? "")")
  case .inlineAttributes(attributes: let attributes, children: let children):
    print("\(String(repeating: "\t", count: depth * 2))InlineAttributes \(attributes)")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  }
}

func printMarkupContent(content: MarkupContent, depth: Int) {
  switch content {
  case .blockDirective(_, _, let children):
    print("\(String(repeating: "\t", count: depth * 2))BlockDirective")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .blockQuote(_, let children):
    print("\(String(repeating: "\t", count: depth * 2))BlockQuote")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .codeBlock(_, let sourceCode):
    print("\(String(repeating: "\t", count: depth * 2))Code Block \(sourceCode)")
  case .text(let text):
    print("\(String(repeating: "\t", count: depth * 2))Text \(text)")
  case .link(destination: let destination, children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Link \(destination ?? "")")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .heading(level: let level, children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Heading \(level)")
    
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .paragraph(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Paragraph")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .softBreak:
    print("\(String(repeating: "\t", count: depth * 2))SoftBreak")
  case .orderedList(startIndex: let startIndex, items: let items):
    print("\(String(repeating: "\t", count: depth * 2))OrderedList \(startIndex)")
    for item in items {
      for child in item.children {
        printMarkupContent(content: child, depth: depth + 1)
      }
    }
  case .unorderedList(items: let items):
    print("\(String(repeating: "\t", count: depth * 2))UnorderedList")
    for item in items {
      for child in item.children {
        printMarkupContent(content: child, depth: depth + 1)
      }
    }
  case .table(head: let head, body: let body):
    print("\(String(repeating: "\t", count: depth * 2))Table \(head.count) \(body.count)")
  case .htmlBlock(text: let text):
    print("\(String(repeating: "\t", count: depth * 2))HTML Block", text)
  case .thematicBreak:
    print("\(String(repeating: "\t", count: depth * 2))ThematicBreak")
  case .doxygenParameter(name: let name, children: let children):
    print("\(String(repeating: "\t", count: depth * 2))DoxygenParameter \(name)")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .doxygenReturns(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))DoxygenReturns")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .emphasis(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Emphasis")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strong(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Strong")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strikethrough(children: let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .inlineCode(code: let code):
    print("\(String(repeating: "\t", count: depth * 2))InlineCode \(code)")
  }
}
