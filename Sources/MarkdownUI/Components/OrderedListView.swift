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
    VStack(alignment: .leading, spacing: 10) {
      ForEach(items.indexed(), id: \.index) { index, item in
        HStack(alignment: .center, spacing: 5) {
          Text("\(index + 1).")
          ForEach(item.children.indexed(), id: \.index) { _, child in
            MarkupContentView(content: child, listDepth: listDepth)
          }
        }
      }
    }
  }
}

#Preview {
  HStack {
    OrderedListView(
      items: [
        .init(checkbox: nil, children: [.text(text: "Hello1"),]),
        .init(checkbox: nil, children: [.text(text: "Hello2"),]),
        .init(checkbox: nil, children: [.text(text: "Hello3"),]),
        .init(checkbox: nil, children: [.text(text: "Hello4"),]),
        .init(checkbox: nil, children: [.text(text: "Hello5"),]),
      ],
      listDepth: 0
    )
    .border(.blue)
    
    Divider()
    
    let document = Document(parsing: """
  1. Hello1
  1. Hello2
  1. Hello3
  1. Hello4
  1. Hello5
  """)
    
    MarkdownView(document: document)
      .border(.blue)
  }
  .padding()
  .border(.red)
}
