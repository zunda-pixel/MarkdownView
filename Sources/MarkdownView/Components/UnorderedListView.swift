//
//  UnorderedListView.swift
//

import SwiftUI
import MarkdownViewParser

public struct UnorderedListView<InlineMarkupContent: InlineMarkupContentViewProtocol>: View {
  public let items: [ListItemContent]
  public let listDepth: Int
  public let unOrderedMark: [Int: String]

  public init(
    items: [ListItemContent],
    listDepth: Int,
    unOrderedMark: [Int: String] = [0: "•", 1: "◦", 2: "▫︎"]
  ) {
    self.items = items
    self.listDepth = listDepth
    self.unOrderedMark = unOrderedMark
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ForEach(items.indexed(), id: \.index) { _, item in
        VStack(alignment: .leading, spacing: 5) {
          ForEach(item.children.indexed(), id: \.index) { _, child in
            HStack(alignment: .center, spacing: 5) {
              if case .unorderedList(_) = child {
                Spacer().frame(width: 10)
              } else {
                if let checkbox = item.checkbox {
                  Image(systemName: checkbox == .checked ? "checkmark.square" : "square")
                } else {
                  SwiftUI.Text(unOrderedMark[listDepth] ?? unOrderedMark[unOrderedMark.count - 1]!)
                }
              }

              MarkupContentView<InlineMarkupContent>(content: child, listDepth: listDepth + 1, isNested: true)
            }
          }
        }
      }
    }
  }
}
