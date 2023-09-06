//
//  CodeBlockView.swift
//

import SwiftUI
import Markdown

struct CodeBlockView: View {
  let language: String?
  let sourceCode: String
  var fileName: String.SubSequence? {
    language?.split(separator: ":", maxSplits: 1).last
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if let fileName {
        Text(fileName.trimming(while: \.isWhitespace))
          .padding(.horizontal, 5)
          .padding(.vertical, 2)
          .foregroundStyle(.background)
          .background {
            CustomRoundedRectangle(
              topLeftRadius: 8,
              topRightRadius: 8,
              bottomLeftRadius: 0,
              bottomRightRadius: 0
            )
            .foregroundStyle(.foreground.opacity(0.5))
          }
      }
      Text(sourceCode)
        .fixedSize(horizontal: true, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .foregroundStyle(.background)
        .background {
          CustomRoundedRectangle(
            topLeftRadius: fileName == nil ? 8 : 0,
            topRightRadius: 8,
            bottomLeftRadius: 8,
            bottomRightRadius: 8
          )
            .foregroundStyle(.foreground)
        }
    }
  }
}

#Preview {
  CodeBlockView(language: "swift: Sample.swift", sourceCode: """
import Foundation
print(Date.now)
""")
}

#Preview {
  let codeBlock = CodeBlock(language: "swift: Sample.swift", """
import Foundation
print(Date.now)
""")
  
  let document = Document([codeBlock])
    
  return MarkdownView(document: document)
}

#Preview {
  let document = Document(parsing: """
```swift: Sample.swift
import Foundation
print(Date.now)
```
""")
  
  return MarkdownView(document: document)
}
