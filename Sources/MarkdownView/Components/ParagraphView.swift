//
//  ParagraphView.swift
//

import SwiftUI
import MarkdownViewParser
import Algorithms

public enum ParagraphElement: Hashable, Sendable {
  case elements(element: [Array<InlineMarkupContent>.SubSequence])
  case image(InlineMarkupContent)
}

public struct ParagraphView<InlineMarkupContentView: InlineMarkupContentViewProtocol>: View {
  public let elements: [ParagraphElement]
  public let isNested: Bool
  
  public init(children: [InlineMarkupContent], isNested: Bool) {
    self.isNested = isNested
    var elements: [ParagraphElement] = []
    var tempElements: [InlineMarkupContent] = []
    
    for child in children {
      if case .image(_, _) = child {
        if !tempElements.isEmpty {
          let newElements = tempElements.split(separator: .softBreak)
          elements.append(.elements(element: newElements))
          tempElements = []
        }
        elements.append(.image(child))
      } else {
        tempElements.append(child)
      }
    }
    if !tempElements.isEmpty {
      let newElements = tempElements.split(separator: .softBreak)
      elements.append(.elements(element: newElements))
    }
    
    self.elements = elements
  }
  
  public var body: some View {
    if isNested {
      ForEach(elements.indexed(), id: \.index) { _, element in
        switch element {
        case .image(let content):
          InlineMarkupContentView(content: content)
        case .elements(let elements):
          ForEach(elements.indexed(), id: \.index) { _, element in
            ForEach(element.indexed(), id: \.index) { _, content in
              InlineMarkupContentView(content: content)
            }
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
            ForEach(elements.indexed(), id: \.index) { _, element in
              FlowLayout(alignment: .leading) {
                ForEach(element.indexed(), id: \.index) { _, content in
                  InlineMarkupContentView(content: content)
                }
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  ScrollView {
    LazyVStack {
      ParagraphView<InlineMarkupContentView>(
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
