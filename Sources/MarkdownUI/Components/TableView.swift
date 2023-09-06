//
//  TableView.swift
//

import SwiftUI
import MarkdownUIParser

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
        [
          .text(text: "Body3"),
          .link(
            destination: "https://google.com",
            children: [.text(text: "LINK")]
          )
        ],
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
