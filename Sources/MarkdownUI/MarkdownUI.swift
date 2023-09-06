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
    ForEach(contents.indexed(), id: \.index) { _, content in
      MarkupContentView(content: content, listDepth: 0)
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
> Text that is a quote[link](https://google.com)

```shell
import Foundation

print("hello")
```

hello

> Text that is a quote
> Text that is a quote

| Head | Head | Head |
| ---- | ---- | ---- |
| Text | Text | Text |
| Text | Text | Text |

1. First list item
23. Second list item
34. Third list item

- First nested list item
- Second nested list item
"""
  )
  
  return MarkdownView(document: document)
    .padding(10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
