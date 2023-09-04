//
//  InlineMarkupContentView.swift
//

import SwiftUI
import Algorithms

struct InlineMarkupContentView: View {
  let content: InlineMarkupContent
  
  var body: some View {
    switch content {
    case .text(let text):
      Text(text)
    case .strong(let children):
      HStack(alignment: .center, spacing: 10) {
        ForEach(children.indexed(), id: \.index) { _, child in
            InlineMarkupContentView(content: child)
        }
      }
      .bold()
    case .strikethrough(let children):
      HStack(alignment: .center, spacing: 10) {
        ForEach(children.indexed(), id: \.index) { _, child in
            InlineMarkupContentView(content: child)
        }
      }
      .strikethrough(pattern: .dash, color: .secondary)
    case .emphasis(let children):
      HStack(alignment: .center, spacing: 10) {
        ForEach(children.indexed(), id: \.index) { _, child in
            InlineMarkupContentView(content: child)
        }
      }
        .italic()
    case .inlineCode(let code):
      Text(code)
        .background(.thinMaterial)
    case .image(let title, let source):
      if let imageURL = source.map({ URL(string: $0) }),
          let imageURL {
        VStack(alignment: .leading, spacing: 10) {
          AsyncImage(url: imageURL) { image in
            image
              .resizable()
              .scaledToFit()
          } placeholder: {
            ProgressView()
          }

          Text(title)
            .foregroundStyle(.secondary)
        }
      }
    case .softBreak:
      EmptyView() // TODO
    case .link(destination: let destination, children: let children):
      if let destination,
         let url = URL(string: destination) {
        SwiftUI.Link(destination: url) {
          ForEach((children ?? []).indexed(), id: \.index) { _, content in
            InlineMarkupContentView(content: content)
          }
        }
      } else {
        ForEach((children ?? []).indexed(), id: \.index) { _, content in
          InlineMarkupContentView(content: content)
        }
      }
    }
  }
}
