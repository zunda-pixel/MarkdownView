//
//  CodeBlockView.swift
//

import SwiftUI
import Markdown

public struct CodeBlockView: View {
  public let language: String?
  public let sourceCode: String
  public var fileName: String.SubSequence? {
    language?.split(separator: ":", maxSplits: 1).last
  }
  
  public init(
    language: String?,
    sourceCode: String
  ) {
    self.language = language
    self.sourceCode = sourceCode
  }
  
  public var copyButton: some View {
    Button {
      #if canImport(AppKit)
      NSPasteboard.general.clearContents()
      NSPasteboard.general.setString(sourceCode, forType: .string)
      #else
      UIPasteboard.general.string = sourceCode
      #endif
    } label: {
      Image(systemName: "clipboard")
        .foregroundStyle(.gray)
    }
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if let fileName {
        SwiftUI.Text(fileName.trimming(while: \.isWhitespace))
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
      SwiftUI.Text(sourceCode)
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
        .overlay(alignment: .topTrailing) {
          copyButton
          .padding(10)
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
