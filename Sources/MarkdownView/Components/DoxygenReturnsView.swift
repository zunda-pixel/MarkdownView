//
//  DoxygenReturnsView.swift
//

import SwiftUI
import Markdown

public struct DoxygenReturnsView: View {
  public let children: [MarkupContent]
  
  public init(
    children: [MarkupContent]
  ) {
    self.children = children
  }

  public var body: some View {
    ForEach(children.indexed(), id: \.index) { _, child in
      MarkupContentView(content: child)
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
