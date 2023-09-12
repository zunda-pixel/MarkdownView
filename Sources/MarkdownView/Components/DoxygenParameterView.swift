//
//  DoxygenParameterView.swift
//

import SwiftUI
import Markdown

public struct DoxygenParameterView: View {
  public let name: String
  public let children: [MarkupContent]
  
  public init(
    name: String,
    children: [MarkupContent]
  ) {
    self.name = name
    self.children = children
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(name)
        .bold()
      ForEach(children.indexed(), id: \.index) { _, child in
        MarkupContentView(content: child)
      }
    }
  }
}

#Preview{
  let source = """
\\param coordinate The coordinate used to center the transformation.
\\param matrix The transformation matrix that describes the transformation.
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
