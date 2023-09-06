//
//  HeadingView.swift
//

import SwiftUI
import MarkdownUIParser
import Markdown

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

private extension View {
  @ViewBuilder
  func ifLet<Value, Content: View>(
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

#Preview {
  List {
    ForEach(1..<6) { level in
      HeadingView(level: level, children: [.text(text: "Title\(level)")])
    }
  }
}

#Preview {
  let document = Document((1..<6).map { i in
    Heading(level: i, [Markdown.Text("Title\(i)")])
  })
    
  return List {
    MarkdownView(document: document)
  }
}

#Preview {
  let document = Document(parsing: """
# Title1
## Title2
### Title3
#### Title4
##### Title5
""")
    
  return List {
    MarkdownView(document: document)
  }
}
