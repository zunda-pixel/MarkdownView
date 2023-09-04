// The Swift Programming Language
// https://docs.swift.org/swift-book

import Algorithms
import Markdown
import MarkdownUIParser
import SwiftUI

struct MarkdownView: View {
  public let document: Document

  public init(document: Document) {
    self.document = document
  }

  var contents: [MarkupContent] {
    MarkdownUIParser.parse(document: document)
  }

  public var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 10) {
        ForEach(contents.indexed(), id: \.index) { _, content in
          MarkupContentView(content: content, listDepth: 0)
        }
      }
    }
  }
}

#Preview{
  let document = Document(
    parsing: """
      # Title1
      ## Title2
      ## Title3
      ## Title4

      > Text that is a quote

      ```
      git status
      git add
      git commit
      ```


      > Text that is a quote
      > Text that is a quote





      | Head | Head | Head |
      | ---- | ---- | ---- |
      | Text | Text | Text |
      | Text | Text | Text |

      100. First list item
             - First nested list item
               - Second nested list item

      - First nested list item
      - Second nested list item
"""
  )
  return MarkdownView(document: document)
    .padding(10)
    .frame(maxWidth: 500, maxHeight: 700, alignment: .center)
    .border(.red)
}
