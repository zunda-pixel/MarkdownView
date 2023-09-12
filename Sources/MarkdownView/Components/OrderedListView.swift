//
//  OrderedListView.swift
//

import Markdown
import SwiftUI

public struct OrderedListView: View {
  public let startIndex: UInt
  public let items: [ListItemContent]
  public let listDepth: Int

  public init(
    startIndex: UInt,
    items: [ListItemContent],
    listDepth: Int
  ) {
    self.startIndex = startIndex
    self.items = items
    self.listDepth = listDepth
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ForEach(items.indexed(), id: \.index) { index, item in
        var unorderedListContains: Bool {
          item.children.contains { child in
            if case .unorderedList(_) = child {
              return true
            } else {
              return false
            }
          }
        }

        if unorderedListContains {
          VStack(alignment: .leading, spacing: 5) {
            if let child = item.children.first {
              FlowLayout {
                SwiftUI.Text("\(Int(startIndex) + index).")
                MarkupContentView(content: child, listDepth: listDepth)
              }
            }

            if item.children.count > 1 {
              ForEach(1..<item.children.count, id: \.self) { i in
                let child = item.children[i]
                HStack(alignment: .center, spacing: 5) {
                  Spacer().frame(width: 10)
                  MarkupContentView(content: child, listDepth: listDepth + 1)
                }
              }
            }
          }
        } else {
          HStack(alignment: .center, spacing: 5) {
            SwiftUI.Text("\(Int(startIndex) + index).")
            ForEach(item.children.indexed(), id: \.index) { _, child in
              MarkupContentView(content: child, listDepth: listDepth)
            }
          }
        }
      }
    }
  }
}

#Preview{
  List {
    OrderedListView(
      startIndex: 1,
      items: [
        .init(children: [.text(text: "Hello1")]),
        .init(children: [.text(text: "Hello2")]),
        .init(children: [.text(text: "Hello3")]),
        .init(children: [.text(text: "Hello4")]),
        .init(children: [.text(text: "Hello5")]),
      ],
      listDepth: 0
    )
  }
}

#Preview{
  let orderedList = OrderedList(
    (1..<6).map { i in
      ListItem(Paragraph([Markdown.Text("Hello\(i)")]))
    })

  let document = Document([orderedList])

  return List {
    MarkdownView(document: document)
  }
}

#Preview{
  let document = Document(
    parsing: """
1. First list item
   - First nested list item
     - Second nested list item
     - Second nested list item
1. Item1
1. Item2
1. Item4
""")

  return ScrollView {
    LazyVStack(alignment: .leading, spacing: 10) {
      MarkdownView(document: document)
    }
  }
}
