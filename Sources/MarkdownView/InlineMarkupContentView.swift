//
//  InlineMarkupContentView.swift
//

import SwiftUI

struct InlineMarkupContentView: View {
  @Environment(\.font) var font

  let inlineContents: [InlineMarkupContent]

  var contents: [[MultiContent]] {
    var container = AttributeContainer()
    container.font = font
    let contents = inlineContents.split { content in
      return content == .softBreak || content == .lineBreak
    }

    return contents.map { content in
      let multiContents = MultiContentParser.multiContents(
        contents: content,
        container: container
      ) { _, container in return container }
      let compressedMultiContents = MultiContentParser.compressMultiContents(
        multiContents: multiContents)
      return compressedMultiContents
    }
  }

  var body: some View {
    ForEach(contents.indexed(), id: \.index) { _, element in
      ForEach(element.indexed(), id: \.index) { _, content in
        switch content {
        case .attributedString(let string):
          Text(string)
        case .image(let title, let source, let link):
          if let imageURL = source.map({ URL(string: $0) }),
            let imageURL
          {
            if let link {
              Link(destination: link) {
                AsyncImage(url: imageURL) { image in
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100)
                } placeholder: {
                  Text(title)
                }
              }
            } else {
              AsyncImage(url: imageURL) { image in
                image
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100)
              } placeholder: {
                Text(title)
              }
            }
          }
        case .inlineHTML(let html, let link):
          if let link {
            SwiftUI.Link(destination: link) {
              HTMLView(html: html)
            }
          } else {
            HTMLView(html: html)
          }
        }
      }
    }
  }
}
