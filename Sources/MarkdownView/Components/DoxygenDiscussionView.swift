//
//  DoxygenDiscussionView.swift
//

import Markdown
import SwiftUI

public struct DoxygenDiscussionView: View {
  public let children: [MarkupContent]

  public init(
    children: [MarkupContent]
  ) {
    self.children = children
  }

  public var body: some View {
    ForEach(children, id: \.self) { child in
      MarkupContentView(content: child)
    }
  }
}

#Preview {
  let source = """
    \\discussion This object can give other objects in your program magical powers.
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
