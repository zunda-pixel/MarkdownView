//
//  TableView.swift
//

import SwiftUI
import MarkdownViewParser
import Markdown

struct TableView: View {
  let headItems: [InlineMarkupContent]
  let bodyItems: [[[InlineMarkupContent]]]
  
  var body: some View {
    Grid {
      GridRow {
        ForEach(headItems.indexed(), id: \.index) { _, item in
          InlineMarkupContentView(content: item)
        }
      }

      Divider()

      ForEach(bodyItems.indexed(), id: \.index) { _, items in
        GridRow {
          ForEach(items.indexed(), id: \.index) { _, items in
            HStack(alignment: .center, spacing: 0) {
              ForEach(items.indexed(), id: \.index) { _, item in
                InlineMarkupContentView(content: item)
              }
            }
          }
        }
        Divider()
      }
    }
  }
}

#Preview {
  TableView(
    headItems: [
      .text(text: "Head1"),
      .text(text: "Head2"),
      .text(text: "Head3"),
    ],
    bodyItems: [
      [
        [.text(text: "Body1"),],
        [.text(text: "Body2"),],
        [.text(text: "Body3"),],
      ],
      [
        [.text(text: "Body4"),],
        [.text(text: "Body5"),],
        [.text(text: "Body6"),],
      ],
    ]
  )
  .padding(10)
}

#Preview {
  let table = Markdown.Table(
    header: .init([
      Markdown.Table.Cell([Markdown.Text("Head1")]),
      Markdown.Table.Cell([Markdown.Text("Head2")]),
      Markdown.Table.Cell([Markdown.Text("Head3")]),
    ]),
    body: .init([
      .init([
        Markdown.Table.Cell([Markdown.Text("Body1")]),
        Markdown.Table.Cell([Markdown.Text("Body2")]),
        Markdown.Table.Cell([Markdown.Text("Body3")]),
      ]),
      .init([
        Markdown.Table.Cell([Markdown.Text("Body4")]),
        Markdown.Table.Cell([Markdown.Text("Body5")]),
        Markdown.Table.Cell([Markdown.Text("Body6")]),
      ]),
    ])
  )
  
  let document = Document([table])
    
  return MarkdownView(document: document).padding(10)
}

#Preview {
  let document = Document(parsing: """
| Head1 | Head2 | Head3 |
| ----- | ----- | ----- |
| Body1 | Body2 | Body3 |
| Body4 | Body5 | Body6 |
""")

  return MarkdownView(document: document).padding(10)
}

