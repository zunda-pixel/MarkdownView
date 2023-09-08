//
//  MarkdownView.swift
//

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
      MarkupContentView(content: content, listDepth: 0, isNested: false)
    }
  }
}

#Preview {
  let source = """
# Title1

Content1

## Title2

### Title3

#### Title4

##### Title5

*italic*
**bold**
~~strikethrough~~
`code`

> *italic1*italic2
> **bold**
> ~~strikethrough~~
> `code`

`Markdown` is a lightweight markup language for creating formatted text using a plain-text editor.
John Gruber created Markdown in 2004 as a markup language that is easy to read in its source code form.

> Text that is a quote
> Text that is a quote[link](https://google.com)

```swift: Sample.swift
import Foundation

print("hello")
```

![GitHub Logo](https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png)

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

1. First list item
   - First nested list item
     - Second nested list item
"""
  
  let document = Document(parsing: source, options: [.parseBlockDirectives, .parseMinimalDoxygen, .parseSymbolLinks])
  
  return ScrollView {
    LazyVStack(alignment: .leading, spacing: 10) {
      MarkdownView(document: document)
    }
    .padding(10)
  }
}
