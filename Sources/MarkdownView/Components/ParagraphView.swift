//
//  ParagraphView.swift
//

import Algorithms
import MarkdownViewParser
import SwiftUI

public struct ParagraphView: View {
  public let children: [InlineMarkupContent]
  public let isNested: Bool

  public init(
    children: [InlineMarkupContent],
    isNested: Bool
  ) {
    self.isNested = isNested
    self.children = children
  }

  public var body: some View {
    if isNested {
      MultiInlineMarkupContentView(inlineContents: children)
    } else {
      VStack(alignment: .leading, spacing: 5) {
        MultiInlineMarkupContentView(inlineContents: children)
      }
    }
  }
}

#Preview{
  ScrollView {
    LazyVStack {
      ParagraphView(
        children: [
          .text(text: "Text1"),
          .image(
            title: "GitHub Header",
            source: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"),
          .text(text: "Text2"),
          .image(
            title: "Title",
            source: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"),
          .link(destination: "https://apple.com", children: [.text(text: "Apple Link")]),
          .text(text: "Text3"),
        ],
        isNested: false
      )
    }
    //.frame(maxWidth: 300)
  }
}
