//
//  HeadingView.swift
//

import SwiftUI
import MarkdownUIParser

struct HeadingView: View {
  let level: Int
  let children: [InlineMarkupContent]
  let headingFonts: [Int: Font] = [
    1: .title,
    2: .title2,
    3: .title3,
  ]
  
  var body: some View {
    FlowLayout {
      ForEach(children.indexed(), id: \.index) { _, content in
        InlineMarkupContentView(content: content)
      }
    }
    .bold()
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
