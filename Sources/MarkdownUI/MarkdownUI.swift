// The Swift Programming Language
// https://docs.swift.org/swift-book

import Algorithms
import Markdown
import SwiftUI
import MarkdownUIParser

struct MarkdownView: View {
  let markdown: String

  var contents: [MarkupContent] {
    MarkdownUIParser.parse(document: Document(parsing: markdown))
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(contents.indexed(), id: \.index) { _, content in
        MarkupContentView(content: content, listDepth: 0)
      }
    }
  }
}

#Preview{
  MarkdownView(
    markdown: """
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
  .padding(10)
  .frame(maxWidth: 500, maxHeight: 700, alignment: .center)
  .border(.red)
}
