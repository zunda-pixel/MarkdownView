//
//  DoxygenNoteView.swift
//

import Markdown
import SwiftUI

public struct DoxygenNoteView: View {
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
    \\note This method is only meant to be called an odd number of times.
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
