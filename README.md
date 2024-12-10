# MarkdownView

MarkdownView uses [swift-markdown](https://github.com/apple/swift-markdown) as Parser

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2FMarkdownView%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/zunda-pixel/MarkdownView)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2FMarkdownView%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/zunda-pixel/MarkdownView)

<img width="644" alt="Markdown Sample" src="https://github.com/zunda-pixel/MarkdownView/assets/47569369/38bd1d7f-ec8d-4380-90ef-dc882375fa59">

```swift
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
        ForEach(contents, id: \.self) { content in
          MarkupContentView(content: content)
        }
      }
    }
  }
}
```

## Adding MarkdownView as a Dependency

To use the MarkdownView plugin in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/zunda-pixel/MarkdownView", from: "0.3.0"),
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
