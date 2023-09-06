//
//  MarkupContentView.swift
//

import Algorithms
import MarkdownUIParser
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
      Text(text)
    case .thematicBreak:
      Divider()
    case .blockDirective(let name, let arguments, let children):
      VStack(alignment: .leading, spacing: 0) {
        Text("@\(name)(\(arguments.joined())) {")
        ForEach(children.indexed(), id: \.index) { _, child in
          HStack(alignment: .center, spacing: 0) {
            Spacer().frame(maxWidth: 10)
            MarkupContentView(content: child, listDepth: listDepth)
          }
        }
        Text("}")
      }
    case .htmlBlock(let text):
      Text(text)
    case .codeBlock(let language, let sourceCode):
      CodeBlockView(language: language, sourceCode: sourceCode)
    case .link(let destination, let children):
      if let destination,
         let url = URL(string: destination)
      {
        Link(destination: url) {
          FlowLayout {
            ForEach(children.indexed(), id: \.index) { _, content in
              InlineMarkupContentView(content: content)
            }
          }
        }
      } else {
        FlowLayout {
          ForEach(children.indexed(), id: \.index) { _, content in
            InlineMarkupContentView(content: content)
          }
        }
      }
    case .heading(let level, let children):
      HeadingView(level: level, children: children)
    case .paragraph(let children):
      FlowLayout {
        ForEach(children.indexed(), id: \.index) { _, content in
          InlineMarkupContentView(content: content)
        }
      }
    case .blockQuote(let kind, let blockChildren):
      BlockQuoteView(kind: kind, blockChildren: blockChildren, listDepth: listDepth)
    case .orderedList(let items):
      OrderedListView(items: items, listDepth: listDepth)
    case .unorderedList(let items):
      UnorderedListView(items: items,  listDepth: listDepth)
    case .table(let headItems, let bodyItems):
      TableView(headItems: headItems, bodyItems: bodyItems)
    case .softBreak:
      EmptyView() // TODO
    }
  }
}
