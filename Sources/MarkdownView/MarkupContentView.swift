//
//  MarkupContentView.swift
//

import Algorithms
import SwiftUI

public struct MarkupContentView: View {
  public let content: MarkupContent
  public let listDepth: Int

  public init(
    content: MarkupContent,
    listDepth: Int
  ) {
    self.content = content
    self.listDepth = listDepth
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
      MultiInlineMarkupContentView(inlineContents: children)
        .bold()
    case .strikethrough(let children):
      MultiInlineMarkupContentView(inlineContents: children)
        .strikethrough(pattern: .dash, color: .secondary)
    case .emphasis(let children):
      MultiInlineMarkupContentView(inlineContents: children)
        .italic()
    case .doxygenParameter(let name, let children):
      DoxygenParameterView(name: name, children: children, listDepth: listDepth)
    case .doxygenReturns(let children):
      DoxygenReturnsView(children: children, listDepth: listDepth)
    case .blockDirective(let name, let arguments, let children):
      BlockDirectiveView(name: name, arguments: arguments, children: children, listDepth: listDepth)
    case .htmlBlock(let html):
      HTMLView(html: html)
    case .codeBlock(let language, let sourceCode):
      CodeBlockView(language: language, sourceCode: sourceCode)
    case .link(let destination, let children):
      LinkView(destination: destination, children: children)
    case .heading(let level, let children):
      HeadingView(level: level, children: children)
    case .paragraph(let children):
      ParagraphView(children: children)
    case .blockQuote(let kind, let children):
      BlockQuoteView(kind: kind, children: children, listDepth: listDepth)
    case .orderedList(let startIndex, let items):
      OrderedListView(startIndex: startIndex, items: items, listDepth: listDepth)
    case .unorderedList(let items):
      UnorderedListView(items: items, listDepth: listDepth)
    case .table(let head, let body):
      TableView(headItems: head, bodyItems: body)
    case .softBreak:
      EmptyView()
    }
  }
}
