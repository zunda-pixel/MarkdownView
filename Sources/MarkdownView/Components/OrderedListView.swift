//
//  OrderedListView.swift
//

import SwiftUI
import MarkdownViewParser
import Markdown

public struct OrderedListView<InlineMarkupContent: InlineMarkupContentViewProtocol>: View {
  public let items: [ListItemContent]
  public let listDepth: Int
  
  public init(
    items: [ListItemContent],
    listDepth: Int
  ) {
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
                SwiftUI.Text("\(index + 1).")
                MarkupContentView<InlineMarkupContent>(content: child, listDepth: listDepth, isNested: true)
              }
            }
            
            if item.children.count > 1 {
              ForEach(1..<item.children.count, id: \.self) { i in
                let child = item.children[i]
                HStack(alignment: .center, spacing: 5) {
                  Spacer().frame(width: 10)
                  MarkupContentView<InlineMarkupContent>(content: child, listDepth: listDepth + 1, isNested: true)
                }
              }
            }
          }
        } else {
          HStack(alignment: .center, spacing: 5) {
            SwiftUI.Text("\(index + 1).")
            ForEach(item.children.indexed(), id: \.index) { _, child in
              MarkupContentView<InlineMarkupContent>(content: child, listDepth: listDepth, isNested: true)
            }
          }
        }
      }
    }
  }
}

#Preview {
  List {
    OrderedListView<InlineMarkupContentView>(
      items: [
        .init(children: [.text(text: "Hello1"),]),
        .init(children: [.text(text: "Hello2"),]),
        .init(children: [.text(text: "Hello3"),]),
        .init(children: [.text(text: "Hello4"),]),
        .init(children: [.text(text: "Hello5"),]),
      ],
      listDepth: 0
    )
  }
}

#Preview {
  let orderedList = OrderedList((1..<6).map { i in
    ListItem(Paragraph([Markdown.Text("Hello\(i)")]))
  })
  
  let document = Document([orderedList])
    
  return List {
    MarkdownView(document: document)
  }
}

#Preview {
  let document = Document(parsing: """
1. First list item
   - First nested list item
     - Second nested list item
     - Second nested list item

1. Item1
1. Item2
1. Item4
""")

  return List {
    MarkdownView(document: document)
  }
}
