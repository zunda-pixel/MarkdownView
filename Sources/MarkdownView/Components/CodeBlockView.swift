//
//  CodeBlockView.swift
//

import Markdown
import SwiftUI

public struct CodeBlockView: View {
  public let language: String?
  public let sourceCode: String
  public let cornerRadius: CGFloat = 8

  public var fileName: String.SubSequence? {
    language?.split(separator: ":", maxSplits: 1)[safe: 1]
  }

  public init(
    language: String?,
    sourceCode: String
  ) {
    self.language = language
    var sourceCode = sourceCode

    if !sourceCode.suffix(2).allSatisfy(\.isNewline) && sourceCode.last?.isNewline == true {
      sourceCode.removeLast()
    }

    self.sourceCode = sourceCode
  }

  var copyButton: some View {
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
          .background(
            .foreground.opacity(0.5),
            in: CustomRoundedRectangle(
              topLeftRadius: cornerRadius,
              topRightRadius: cornerRadius,
              bottomLeftRadius: 0,
              bottomRightRadius: 0
            )
          )
      }
      SwiftUI.Text(sourceCode)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .foregroundStyle(.background)
        .background {
          CustomRoundedRectangle(
            topLeftRadius: fileName == nil ? cornerRadius : 0,
            topRightRadius: cornerRadius,
            bottomLeftRadius: cornerRadius,
            bottomRightRadius: cornerRadius
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

#Preview{
  CodeBlockView(
    language: "swift: Sample.swift",
    sourceCode: """
      import Foundation
      print(Date.now)
      """)
}

#Preview{
  let codeBlock = CodeBlock(
    language: "swift: Sample.swift",
    """
    import Foundation
    print(Date.now)
    """)

  let document = Document([codeBlock])

  return MarkdownView(document: document)
}

#Preview{
  let document = Document(
    parsing: """
      ```swift: Sample.swift
      import Foundation
      print(Date.now)
      ```
      """)

  return MarkdownView(document: document)
}
