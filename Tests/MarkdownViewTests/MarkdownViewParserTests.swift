import Algorithms
import Markdown
import Testing

@testable import MarkdownView

@Test
func testFileExtensionNameParse() {
  let content = "swift: Sample.swift "
  let elements = content.split(separator: ":", maxSplits: 1)
  let fileExtension = elements[0]
  let fileName = elements[1]

  #expect(fileExtension == "swift")
  #expect(fileName.trimming(while: \.isWhitespace) == "Sample.swift")
}

func printMarkup(markup: Markup, depth: Int) {
  print(String(repeating: "\t", count: depth * 2), type(of: markup))
  for child in markup.children {
    printMarkup(markup: child, depth: depth + 1)
  }
}

func printInlineMarkupContent(content: InlineMarkupContent, depth: Int) {
  switch content {
  case .image(let title, let source):
    print("\(String(repeating: "\t", count: depth * 2))Image \(title) \(source ?? "")")
  case .text(let text):
    print("\(String(repeating: "\t", count: depth * 2))Text \(text)")
  case .lineBreak:
    print("\(String(repeating: "\t", count: depth * 2))LineBreak")
  case .softBreak:
    print("\(String(repeating: "\t", count: depth * 2))SoftBreak")
  case .link(let destination, let title, let children):
    print("\(String(repeating: "\t", count: depth * 2))Link \(destination ?? "") \(title ?? "")")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strong(let children):
    print("\(String(repeating: "\t", count: depth * 2))Strong")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strikethrough(let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .emphasis(let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .inlineCode(let code):
    print("\(String(repeating: "\t", count: depth * 2))InlineCode \(code)")
  case .inlineHTML(let html):
    print("\(String(repeating: "\t", count: depth * 2))InlineHTML \(html)")
  case .symbolLink(let destination):
    print("\(String(repeating: "\t", count: depth * 2))SymbolLink \(destination ?? "")")
  case .inlineAttributes(let attributes, let children):
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
  case .link(let destination, let title, let children):
    print("\(String(repeating: "\t", count: depth * 2))Link \(destination ?? "") \(title ?? "")")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .heading(let level, let children):
    print("\(String(repeating: "\t", count: depth * 2))Heading \(level)")

    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .paragraph(let children):
    print("\(String(repeating: "\t", count: depth * 2))Paragraph")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .softBreak:
    print("\(String(repeating: "\t", count: depth * 2))SoftBreak")
  case .orderedList(let startIndex, let items):
    print("\(String(repeating: "\t", count: depth * 2))OrderedList \(startIndex)")
    for item in items {
      for child in item.children {
        printMarkupContent(content: child, depth: depth + 1)
      }
    }
  case .unorderedList(let items):
    print("\(String(repeating: "\t", count: depth * 2))UnorderedList")
    for item in items {
      for child in item.children {
        printMarkupContent(content: child, depth: depth + 1)
      }
    }
  case .table(let head, let body):
    print("\(String(repeating: "\t", count: depth * 2))Table \(head.count) \(body.count)")
  case .htmlBlock(let text):
    print("\(String(repeating: "\t", count: depth * 2))HTML Block", text)
  case .thematicBreak:
    print("\(String(repeating: "\t", count: depth * 2))ThematicBreak")
  case .doxygenParameter(let name, let children):
    print("\(String(repeating: "\t", count: depth * 2))DoxygenParameter \(name)")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .doxygenReturns(let children):
    print("\(String(repeating: "\t", count: depth * 2))DoxygenReturns")
    for child in children {
      printMarkupContent(content: child, depth: depth + 1)
    }
  case .emphasis(let children):
    print("\(String(repeating: "\t", count: depth * 2))Emphasis")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strong(let children):
    print("\(String(repeating: "\t", count: depth * 2))Strong")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .strikethrough(let children):
    print("\(String(repeating: "\t", count: depth * 2))Strikethrough")
    for child in children {
      printInlineMarkupContent(content: child, depth: depth + 1)
    }
  case .inlineCode(let code):
    print("\(String(repeating: "\t", count: depth * 2))InlineCode \(code)")
  }
}
