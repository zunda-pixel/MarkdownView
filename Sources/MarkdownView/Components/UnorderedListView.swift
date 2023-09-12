//
//  UnorderedListView.swift
//

import SwiftUI

public struct UnorderedListView: View {
  @Environment(\.listDepth) var listDepth
  public let items: [ListItemContent]
  public let unOrderedMark: [UInt: String]

  public init(
    items: [ListItemContent],
    unOrderedMark: [UInt: String] = [0: "•", 1: "◦", 2: "▫︎"]
  ) {
    self.items = items
    self.unOrderedMark = unOrderedMark
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      ForEach(items.indexed(), id: \.index) { _, item in
        VStack(alignment: .leading, spacing: 5) {
          ForEach(item.children.indexed(), id: \.index) { _, child in
            HStack(alignment: .top, spacing: 5) {
              if case .unorderedList(_) = child {
                Spacer().frame(width: 10)
              } else {
                if let checkbox = item.checkbox {
                  Image(systemName: checkbox == .checked ? "checkmark.square" : "square")
                } else {
                  Text(unOrderedMark[listDepth] ?? unOrderedMark[UInt(unOrderedMark.count - 1)]!)
                }
              }
              VStack(alignment: .leading) {
                MarkupContentView(content: child)
                  .environment(\.listDepth, listDepth + 1)
              }
            }
          }
        }
      }
    }
  }
}
