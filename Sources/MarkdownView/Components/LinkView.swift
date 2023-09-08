//
//  LinkView.swift
//

import SwiftUI
import MarkdownViewParser
import Markdown

public struct LinkView<InlineMarkupContentView: InlineMarkupContentViewProtocol>: View {
  let destination: String?
  let children: [InlineMarkupContent]
  
  public init(
    destination: String?,
    children: [InlineMarkupContent]
  ) {
    self.destination = destination
    self.children = children
  }
  
  public var body: some View {
    if let destination,
       let url = URL(string: destination)
    {
      SwiftUI.Link(destination: url) {
        FlowLayout {
          ForEach(children.indexed(), id: \.index) { _, content in
            InlineMarkupContentView(content: content)
          }
        }
      }
    } else {
      FlowLayout {
        ForEach(children.indexed(), id: \.index) { _, content in
          InlineMarkupContentView(content: content)
        }
      }
    }
  }
}

#Preview {
  LinkView<InlineMarkupContentView>(destination: "https://apple.com", children: [
    .text(text: "Apple Link")
  ])
}

#Preview {
  let link = Markdown.Link(destination: "https://apple.com", [Markdown.Text("Apple Link")])
  let document = Markdown.Document([Paragraph(link)])
  return MarkdownView(document: document)
}

#Preview {
  let document = Document(parsing: """
[Apple Link](https://apple.com)
""")
    
  return MarkdownView(document: document)
}
