//
//  LinkView.swift
//

import Markdown
import SwiftUI

public struct LinkView: View {
  public let destination: String?
  public let title: String?
  public let children: [InlineMarkupContent]

  public init(
    destination: String?,
    title: String?,
    children: [InlineMarkupContent]
  ) {
    self.destination = destination
    self.title = title
    self.children = children
  }

  public var body: some View {
    if let destination,
      let url = URL(string: destination)
    {
      SwiftUI.Link(destination: url) {
        InlineMarkupContentView(inlineContents: children)
      }
      .ifLet(title) { view, title in
        view.accessibilityLabel(title)
      }
    } else {
      InlineMarkupContentView(inlineContents: children)
        .ifLet(title) { view, title in
          view.accessibilityLabel(title)
        }
    }
  }
}

#Preview {
  LinkView(
    destination: "https://apple.com",
    title: "Apple Link Destination",
    children: [
      .text(text: "Apple Link")
    ])
}

#Preview {
  let link = Markdown.Link(destination: "https://apple.com", [Markdown.Text("Apple Link")])
  let document = Markdown.Document([Paragraph(link)])
  return MarkdownView(document: document)
}

#Preview {
  let document = Document(parsing: "[Apple Link](https://apple.com)")

  return MarkdownView(document: document)
}
