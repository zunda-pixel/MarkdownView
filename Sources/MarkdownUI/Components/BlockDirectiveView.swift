//
//  BlockDirectiveView.swift
//

import SwiftUI
import MarkdownUIParser

struct BlockDirectiveView: View {
  let name: String
  let arguments: [Substring]
  let children: [MarkupContent]
  let listDepth: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      SwiftUI.Text("@\(name)(\(arguments.joined())) {")
      ForEach(children.indexed(), id: \.index) { _, child in
        HStack(alignment: .center, spacing: 0) {
          Spacer().frame(maxWidth: 10)
          MarkupContentView(content: child, listDepth: listDepth)
        }
      }
      SwiftUI.Text("}")
    }
  }
}
