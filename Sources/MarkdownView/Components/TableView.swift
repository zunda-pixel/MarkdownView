//
//  TableView.swift
//

import SwiftUI
import MarkdownViewParser
import Markdown

struct TableView: View {
  let headItems: [InlineMarkupContent]
  let bodyItems: [[[InlineMarkupContent]]]
  let horizontalSpacing: CGFloat = 10
  let verticalSpacing: CGFloat = 8
  
  var body: some View {
    Grid(verticalSpacing: verticalSpacing) {
      GridRow {
        ForEach(headItems.indexed(), id: \.index) { index, item in
          InlineMarkupContentView(content: item)
            .if(index == 0) {
              $0.padding(.leading, horizontalSpacing)
            }
            .if(index == headItems.count - 1) {
              $0.padding(.trailing, horizontalSpacing)
            }
        }
      }
      .bold()

      Divider()
        .gridCellUnsizedAxes(.horizontal)
        .background(.secondary)

      ForEach(bodyItems.indexed(), id: \.index) { index, items in
        GridRow {
          ForEach(items.indexed(), id: \.index) { index, items in
            HStack(alignment: .center, spacing: 0) {
              ForEach(items.indexed(), id: \.index) { _, item in
                InlineMarkupContentView(content: item)
              }
            }
            .if(index == 0) {
              $0.padding(.leading, horizontalSpacing)
            }
            .if(index == headItems.count - 1) {
              $0.padding(.trailing, horizontalSpacing)
            }
          }
        }
        
        if index < bodyItems.count - 1 {
          Divider()
            .gridCellUnsizedAxes(.horizontal)
            .background(.secondary)
        }
      }
    }
    .padding(.vertical, verticalSpacing)
    .border(.secondary)
  }
}

private extension View {
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, @ViewBuilder content: (Self) -> Content) -> some View {
    if condition {
      content(self)
    } else {
      self
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
| Body7 | Body8 | Body9 |
""")

  return MarkdownView(document: document).padding(50)
}
