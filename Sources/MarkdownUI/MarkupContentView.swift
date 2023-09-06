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

#Preview {
  MarkdownView(document: .init(parsing: """
> Title1
> Title2
> Title3 Title3Title3Title3Title3Title3Titijijijjijijijijijijijijijijijijijijle3[Link](https://google.com) dfsfsdfs
"""))
}

#Preview{
  let items: [MarkupContent] = [
    .blockQuote(
      kind: .attention,
      children: [
        [
          .text(text: "Hello"),
        ],
      ]
    ),
    .blockDirective(
      name: "area",
      arguments: ["x: Int, y: Int"],
      children: [
        .text(text: "let are = x * y"),
        .text(text: "return area"),
      ]
    ),
    .heading(level: 1, children: [.text(text: "Title1")]),
    .heading(level: 2, children: [.text(text: "Title2")]),
    .heading(level: 3, children: [.text(text: "Title3")]),
    .heading(level: 4, children: [.text(text: "Title4")]),
    .text(text: "Title5"),
    .codeBlock(
      language: "swift:  Sample.swift  ",
      sourceCode: """
        import Foundation
        print("Hello")
        """),
    .orderedList(items: [
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item1")
        ]
      ),
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item2"),
        ]
      ),
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item3")
        ]
      ),
    ]),
    .unorderedList(
      items: [
        .init(
          checkbox: nil,
          children: [.text(text: "Item1")]
        ),
        .init(
          checkbox: nil,
          children: [
            .text(text: "Item2"),
            .unorderedList(
              items: [
                .init(
                  checkbox: nil,
                  children: [
                    .text(text: "Item3-1"),
                    .unorderedList(
                      items: [
                        .init(
                          checkbox: nil,
                          children: [.text(text: "Item4"),]
                        ),
                      ]
                    ),
                    .text(text: "Item3-2"),
                  ]
                ),
              ]
            )
          ]
        ),
        .init(
          checkbox: nil,
          children: [.text(text: "Item5")]
        ),
      ]
    ),
    .unorderedList(items: [
      .init(
        checkbox: .checked,
        children: [.text(text: "Item1")]
      ),
      .init(
        checkbox: .unchecked,
        children: [.text(text: "Item2")]
      ),
      .init(
        checkbox: .checked,
        children: [.text(text: "Item3")]
      ),
    ]),
  ]

  return ScrollView {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(items.indexed(), id: \.index) { _, item in
        MarkupContentView(content: item, listDepth: 0)
        Divider()
      }
    }
  }
  .padding(10)
}
