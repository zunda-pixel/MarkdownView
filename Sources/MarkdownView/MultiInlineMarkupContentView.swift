//
//  MultiInlineMarkupContentView.swift
//

import SwiftUI
import MarkdownViewParser

extension View {
  func markdownAttributes(attributes: String) -> some View {
    self
  }
}

enum MultiContent {
  case attributedString(AttributedString)
  case image(title: String, source: String?, link: URL?)
  case inlineHTML(html: String, link: URL?)
  case unknown(plainText: String, link: URL?)
}


struct MultiInlineMarkupContentView: View {
  @Environment(\.font) var font
  
  let inlineContents: [InlineMarkupContent]
  
  var contents: [MultiContent] {
    var container = AttributeContainer()
    container.font = font
    let multiContents = multiContents(contents: inlineContents, container: container)
    let compressedMultiContents = compressMultiContents(multiContents: multiContents)
    return compressedMultiContents
  }
  
  func compressMultiContents(multiContents: [MultiContent]) -> [MultiContent] {
    var multiContents = multiContents
    
    for i in (0..<multiContents.count).reversed() {
      let content1 = multiContents[i]
      guard let content2 = multiContents[safe: i - 1] else { continue }
      
      if case .attributedString(let attributedString1) = content1 {
        if case .attributedString(var attributedString2) = content2 {
          attributedString2.append(attributedString1)
          multiContents[i - 1] = .attributedString(attributedString2)
          multiContents.remove(at: i)
        }
      }
    }
    
    return multiContents
  }
  
  func customAttribute(attribute: String, baseAttributeContainer: AttributeContainer) -> AttributeContainer {
    return baseAttributeContainer
  }
  
  func multiContents(contents: [InlineMarkupContent], container: AttributeContainer) -> [MultiContent] {
    var multiContents: [MultiContent] = []
    
    for content in contents {
      switch content {
      case .text(let text):
        let attributedString = AttributedString(text, attributes: container)
        multiContents.append(.attributedString(attributedString))
      case .strong(let children):
        var container = container
        container.font = .bold(container.font ?? .body)()
        let contents = self.multiContents(contents: children, container: container)
        multiContents.append(contentsOf: contents)
      case .emphasis(let children):
        var container = container
        container.font = .italic(container.font ?? .body)()
        let contents = self.multiContents(contents: children, container: container)
        multiContents.append(contentsOf: contents)
      case .strikethrough(let children):
        var container = container
        container.strikethroughStyle = .single
        let contents = self.multiContents(contents: children, container: container)
        multiContents.append(contentsOf: contents)
      case .link(let destination, let children):
        var container = container
        if let url = destination.map({ URL(string: $0) }) {
          container.link = url
        }
        
        let contents = self.multiContents(contents: children, container: container)
        multiContents.append(contentsOf: contents)
      case .inlineCode(let code):
        var container = container
        container.backgroundColor = .red // TODO Fix Color
        let attributedString = AttributedString(code, attributes: container)
        multiContents.append(.attributedString(attributedString))
      case .symbolLink(let destination):
        if let destination {
          var container = container
          container.backgroundColor = .yellow // TODO Fix Color
          let attributedString = AttributedString(destination, attributes: container)
          multiContents.append(.attributedString(attributedString))
        }
      case .image(let title, let source):
        multiContents.append(.image(title: title, source: source, link: container.link))
      case .inlineAttributes(let attributes, let children):
        let container = customAttribute(attribute: attributes, baseAttributeContainer: container)
        let contents = self.multiContents(contents: children, container: container)
        multiContents.append(contentsOf: contents)
      case .softBreak, .lineBreak:
        continue
      case .inlineHTML(let html):
        multiContents.append(.inlineHTML(html: html, link: container.link))
      case .unknown(let plainText):
        multiContents.append(.unknown(plainText: plainText, link: container.link))
      }
    }
    
    return multiContents
  }
  
  
  var body: some View {
    ForEach(contents.indexed(), id: \.index) { index, content in
      switch content {
      case .attributedString(let string):
        Text(string)
      case .image(let title, let source, let link):
        if let imageURL = source.map({ URL(string: $0) }),
           let imageURL {
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
            Text(html)
          }
        } else {
          Text(html)
        }
      case .unknown(let plainText, let link):
        if let link {
          SwiftUI.Link(destination: link) {
            Text(plainText)
          }
        } else {
          Text(plainText)
        }
      }
    }
  }
}
