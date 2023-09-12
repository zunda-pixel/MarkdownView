# MarkdownView

MarkdownView uses [swift-markdown](https://github.com/apple/swift-markdown) as Parser

<img width="644" alt="Markdown Sample" src="https://github.com/zunda-pixel/MarkdownView/assets/47569369/38bd1d7f-ec8d-4380-90ef-dc882375fa59">



```swift
import Algorithms
import MarkdownView
import Markdown
import SwiftUI

struct MarkdownView: View {
  let markdown: String

  var contents: [MarkupContent] {
    let document = Document(
        parsing: markdown,
        options: [.parseBlockDirectives, .parseSymbolLinks, .parseMinimalDoxygen, .parseSymbolLinks]
    )
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

## Adding MarkdownView as a Dependency

To use the MarkdownView plugin in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/zunda-pixel/MarkdownView", from: "0.0.3"),
```
Include "MarkdownView" as a dependency for your target:

```swift
.target(
  name: "<target>",
  dependencies: [
    .product(name: "MarkdownView", package: "MarkdownView"),
  ]
),
```
