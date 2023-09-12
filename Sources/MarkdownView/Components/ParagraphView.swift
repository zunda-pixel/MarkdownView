//
//  ParagraphView.swift
//

import Algorithms
import SwiftUI

public struct ParagraphView: View {
  public let children: [InlineMarkupContent]

  public init(
    children: [InlineMarkupContent]
  ) {
    self.children = children
  }

  public var body: some View {
    MultiInlineMarkupContentView(inlineContents: children)
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
        ]
      )
    }
    //.frame(maxWidth: 300)
  }
}
