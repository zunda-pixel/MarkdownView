//
//  HeadingView.swift
//

import Markdown
import MarkdownViewParser
import SwiftUI

public struct HeadingView: View {
  public let level: Int
  public let children: [InlineMarkupContent]
  public let headingFonts: [Int: Font]

  public init(
    level: Int,
    children: [InlineMarkupContent],
    headingFonts: [Int: Font] = [1: .title, 2: .title2, 3: .title3]
  ) {
    self.level = level
    self.children = children
    self.headingFonts = headingFonts
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      MultiInlineMarkupContentView(inlineContents: children)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)

      if level < 3 {
        Rectangle()
          .fill(.secondary)
          .frame(maxHeight: 1)
      }
    }
    .ifLet(headingFonts[level]) { view, font in
      view.font(font)
    }
  }
}

extension View {
  @ViewBuilder
  fileprivate func ifLet<Value, Content: View>(
    _ value: Value?,
    @ViewBuilder content: (Self, Value) -> Content
  ) -> some View {
    if let value {
      content(self, value)
    } else {
      self
    }
  }
}

#Preview{
  VStack {
    ForEach(1..<6) { level in
      HeadingView(
        level: level,
        children: [
          .text(text: "Title\(level)"),
          .link(destination: "https://apple.com", children: [.text(text: "Apple Link")]),
        ]
      )
    }
  }
}

#Preview{
  let document = Document(
    (1..<6).map { i in
      Heading(
        level: i,
        [
          Markdown.Text("Title\(i)")
        ]
      )
    })

  return VStack {
    MarkdownView(document: document)
  }
}

#Preview{
  let document = Document(
    parsing: """
# Title1 [Apple Link](https://apple.com) `code` *italic*
## Title2
### Title3
#### Title4
##### Title5
""")

  return VStack {
    MarkdownView(document: document)
  }
}
