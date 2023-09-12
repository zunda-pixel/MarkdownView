//
//  DoxygenParameterView.swift
//

import SwiftUI
import Markdown

public struct DoxygenParameterView: View {
  public let name: String
  public let children: [MarkupContent]
  public let listDepth: Int
  
  public init(
    name: String,
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.name = name
    self.children = children
    self.listDepth = listDepth
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(name)
        .bold()
      ForEach(children.indexed(), id: \.index) { _, child in
        MarkupContentView(content: child, listDepth: listDepth, isNested: true)
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
