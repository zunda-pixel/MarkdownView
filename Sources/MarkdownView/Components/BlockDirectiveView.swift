//
//  BlockDirectiveView.swift
//

import SwiftUI
import Markdown

public struct BlockDirectiveView: View {
  public let name: String
  public let arguments: [Substring]
  public let children: [MarkupContent]
  public let listDepth: Int

  public init(
    name: String,
    arguments: [Substring],
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.name = name
    self.arguments = arguments
    self.children = children
    self.listDepth = listDepth
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      SwiftUI.Text("\(Text("@\(name)").bold())(\(arguments.joined())) {")
      ForEach(children.indexed(), id: \.index) { _, child in
        HStack(alignment: .center, spacing: 0) {
          Spacer().frame(maxWidth: 10)
          MarkupContentView(content: child, listDepth: listDepth, isNested: true)
        }
      }
      SwiftUI.Text("}")
    }
  }
}

#Preview {
  let markdown = """
@Wrapped(paperStyle: shin) {
}


@Outer {
  @TwoSpaces {
      @FourSpaces
  }
}
"""
  
  let document = Document(parsing: markdown, options: [.parseBlockDirectives])
  
  return ScrollView {
    LazyVStack(alignment: .leading, spacing: 10) {
      MarkdownView(document: document)
    }
  }
}
