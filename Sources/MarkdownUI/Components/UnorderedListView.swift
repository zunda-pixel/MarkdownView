//
//  UnorderedListView.swift
//

import SwiftUI
import MarkdownUIParser

struct UnorderedListView: View {
  let items: [ListItemContent]
  let listDepth: Int
  let unOrderedMark: [Int: String] = [
    0: "•",
    1: "◦",
    2: "▫︎",
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(items.indexed(), id: \.index) { _, item in
        VStack(alignment: .leading, spacing: 10) {
          ForEach(item.children.indexed(), id: \.index) { _, child in
            HStack(alignment: .center, spacing: 10) {
              if case .unorderedList(_) = child {
                Spacer().frame(width: 10)
              } else {
                if let checkbox = item.checkbox {
                  Image(systemName: checkbox == .checked ? "checkmark.square" : "square")
                } else {
                  Text(unOrderedMark[listDepth] ?? unOrderedMark[unOrderedMark.count - 1]!)
                }
              }

              MarkupContentView(content: child, listDepth: listDepth + 1)
            }
          }
        }
      }
    }
  }
}
