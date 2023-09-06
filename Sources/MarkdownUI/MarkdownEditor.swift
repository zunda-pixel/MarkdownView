//
//  MarkdownEditor.swift
//

import SwiftUI
import Markdown

struct MarkdownEditor: View {
  @State var sourceCode: String
  var document: Document {
    Document(parsing: sourceCode)
  }
  var body: some View {
    HStack {
      TextEditor(text: $sourceCode)
      Divider()
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 10) {
          MarkdownView(document: document)
        }
      }
      Divider()
      ScrollView {
        SwiftUI.Text(document.debugDescription())
      }
    }
  }
}

#Preview {
  MarkdownEditor(sourceCode: """
# Title1

Content1

## Title2

## Title3

## Title4

> Text that is a quote
> Text that is a quote[link](https://google.com)

```swift: Sample.swift
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

1. First list item
   - First nested list item
     - Second nested list item
""")
}
