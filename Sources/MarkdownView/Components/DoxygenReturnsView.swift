//
//  DoxygenReturnsView.swift
//

import SwiftUI
import Markdown

public struct DoxygenReturnsView: View {
  public let children: [MarkupContent]
  public let listDepth: Int
  
  public init(
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.children = children
    self.listDepth = listDepth
  }

  public var body: some View {
    ForEach(children.indexed(), id: \.index) { _, child in
      MarkupContentView(content: child, listDepth: listDepth, isNested: true)
    }
  }
}

#Preview{
  let source = """
\\returns A freshly-created object.
"""

  let document = Document(
    parsing: source,
    options: [.parseBlockDirectives, .parseMinimalDoxygen]
  )
  
  return ScrollView {
    LazyVStack(alignment: .leading) {
      MarkdownView(document: document)
    }
  }
}
