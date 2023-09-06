//
//  OrderedListView.swift
//

import SwiftUI
import MarkdownUIParser
import Markdown

struct OrderedListView: View {
  let items: [ListItemContent]
  let listDepth: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ForEach(items.indexed(), id: \.index) { index, item in
        HStack(alignment: .center, spacing: 5) {
          SwiftUI.Text("\(index + 1).")
          ForEach(item.children.indexed(), id: \.index) { _, child in
            MarkupContentView(content: child, listDepth: listDepth, isNested: true)
          }
        }
      }
    }
  }
}

#Preview {
  List {
    OrderedListView(
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
1. Hello1
1. Hello2
1. Hello3
1. Hello4
1. Hello5
""")

  return List {
    MarkdownView(document: document)
  }
}
