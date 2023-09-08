# MarkdownView

MarkdownView uses [swift-markdown](https://github.com/apple/swift-markdown) as Parser

## Sample

<img width="315" alt="Markdown Sample" src="https://github.com/zunda-pixel/MarkdownView/assets/47569369/4d267be4-6ae2-4dae-9f88-11f91ebdc494">

```swift
struct ContentView: View {
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

> Text that is a `quote`
> Text that is a `quote`

> Tip: Tip Description
> Tip Description

> Attention: Attention Description
> Attention Description

```swift: Sample.swift
import Foundation

print("hello")
/```

![GitHub Logo](https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png)

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
  
  var body: some View {
    let document = Document(
      parsing: source,
      options: [.parseBlockDirectives, .parseMinimalDoxygen, .parseSymbolLinks]
    )
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 10) {
        MarkdownView(document: document)
      }
    }
  }
}
```
