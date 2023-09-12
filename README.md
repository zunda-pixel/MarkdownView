# MarkdownView

MarkdownView uses [swift-markdown](https://github.com/apple/swift-markdown) as Parser

<img width="343" alt="Markdown Sample" src="https://github.com/zunda-pixel/MarkdownView/assets/47569369/611c1fbb-fd7f-40e5-85d8-256ed25e4be5">

```swift
import MarkdownView
import Markdown
import SwiftUI

struct MarkdownView: View {
  let markdown: String

  var contents: [MarkupContent] {
    let document = Document(parsing: markdown, options: [])
    return MarkdownViewParser.parse(document: document)
  }
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 10) {
        ForEach(contents.indexed(), id: \.index) { _, content in
          MarkupContentView(content: content, listDepth: 0)
        }
      }
    }
  }
}
```
