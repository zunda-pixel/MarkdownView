// The Swift Programming Language
// https://docs.swift.org/swift-book

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
