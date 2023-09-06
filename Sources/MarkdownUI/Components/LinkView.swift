//
//  LinkView.swift
//

import SwiftUI
import MarkdownUIParser

struct LinkView: View {
  let destination: String?
  let children: [InlineMarkupContent]
  
  var body: some View {
    if let destination,
       let url = URL(string: destination)
    {
      Link(destination: url) {
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
