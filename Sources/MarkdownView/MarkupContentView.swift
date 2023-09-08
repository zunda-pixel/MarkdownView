//
//  MarkupContentView.swift
//

import Algorithms
import MarkdownViewParser
import SwiftUI

public struct MarkupContentView: View {
  public let content: MarkupContent
  public let listDepth: Int
  public let isNested: Bool

  public init(
    content: MarkupContent,
    listDepth: Int,
    isNested: Bool
  ) {
    self.content = content
    self.listDepth = listDepth
    self.isNested = isNested
  }

  public var body: some View {
    switch content {
    case .text(let text):
      SwiftUI.Text(text)
    case .thematicBreak:
      Divider()
    case .inlineCode(let code):
      InlineCodeView(code: code)
    case .strong(let children):
      VStack {
        ForEach(children.indexed(), id: \.index) { _, child in
          InlineMarkupContentView(content: child)
        }
      }
      .bold()
    case .strikethrough(let children):
      VStack {
        ForEach(children.indexed(), id: \.index) { _, child in
          InlineMarkupContentView(content: child)
        }
      }
      .strikethrough(pattern: .dash, color: .secondary)
    case .emphasis(let children):
      VStack {
        ForEach(children.indexed(), id: \.index) { _, child in
          InlineMarkupContentView(content: child)
        }
      }
      .italic()
    case .doxygenParameter(let name, let children):
      FlowLayout {
        SwiftUI.Text("\\param \(name)")
        ForEach(children.indexed(), id: \.index) { _, child in
          MarkupContentView(content: child, listDepth: listDepth, isNested: true)
        }
      }
    case .doxygenReturns(let children):
      FlowLayout {
        SwiftUI.Text("\\returns")
        ForEach(children.indexed(), id: \.index) { _, child in
          MarkupContentView(content: child, listDepth: listDepth, isNested: true)
        }
      }
    case .blockDirective(let name, let arguments, let children):
      BlockDirectiveView(name: name, arguments: arguments, children: children, listDepth: listDepth)
    case .htmlBlock(let text):
      SwiftUI.Text(text)
    case .codeBlock(let language, let sourceCode):
      CodeBlockView(language: language, sourceCode: sourceCode)
    case .link(let destination, let children):
      LinkView(destination: destination, children: children)
    case .heading(let level, let children):
      HeadingView(level: level, children: children)
    case .paragraph(let children):
      ParagraphView(children: children, isNested: isNested)
    case .blockQuote(let kind, let blockChildren):
      BlockQuoteView(kind: kind, blockChildren: blockChildren, listDepth: listDepth)
    case .orderedList(let items):
      OrderedListView(items: items, listDepth: listDepth)
    case .unorderedList(let items):
      UnorderedListView(items: items,  listDepth: listDepth)
    case .table(let head, let body):
      TableView(headItems: head, bodyItems: body)
    case .softBreak:
      EmptyView() // TODO
    case .unknown(let plainText):
      VStack(alignment: .leading, spacing: 0) {
        SwiftUI.Text("MarkupContentView UnKnown")
        SwiftUI.Text(plainText)
      }
    }
  }
}
