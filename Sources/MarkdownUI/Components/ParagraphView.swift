//
//  ParagraphView.swift
//

import SwiftUI
import MarkdownUIParser
import Algorithms

enum ParagraphElement: Hashable, Sendable {
  case elements(element: [InlineMarkupContent])
  case image(InlineMarkupContent)
}

struct ParagraphView: View {
  let elements: [ParagraphElement]
  let isNested: Bool
  
  init(children: [InlineMarkupContent], isNested: Bool) {
    self.isNested = isNested
    var elements: [ParagraphElement] = []
    var tempElements: [InlineMarkupContent] = []
    
    for child in children {
      if case .image(_, _) = child {
        if !tempElements.isEmpty {
          elements.append(.elements(element: tempElements))
          tempElements = []
        }
        elements.append(.image(child))
      } else {
        tempElements.append(child)
      }
    }
    if !tempElements.isEmpty {
      elements.append(.elements(element: tempElements))
    }
    
    self.elements = elements
  }
  
  var body: some View {
    if isNested {
      ForEach(elements.indexed(), id: \.index) { _, element in
        switch element {
        case .image(let content):
          InlineMarkupContentView(content: content)
        case .elements(let elements):
          ForEach(elements.indexed(), id: \.index) { _, element in
            InlineMarkupContentView(content: element)
          }
        }
      }
    } else {
      VStack(alignment: .leading, spacing: 5) {
        ForEach(elements.indexed(), id: \.index) { _, content in
          switch content {
          case .image(let element):
            InlineMarkupContentView(content: element)
          case .elements(let elements):
            FlowLayout {
              ForEach(elements.indexed(), id: \.index) { _, item in
                InlineMarkupContentView(content: item)
              }
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  ScrollView {
    LazyVStack {
      ParagraphView(
        children: [
          .text(text: "Text1"),
          .image(title: "GitHub Header", source: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"),
          .text(text: "Text2"),
          .image(title: "Title", source: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"),
          .link(destination: "https://apple.com", children: [.text(text: "Apple Link")]),
          .text(text: "Text3"),
        ],
        isNested: false
      )
    }
    //.frame(maxWidth: 300)
  }
}
