//
//  BlockDirectiveView.swift
//

import SwiftUI
import MarkdownViewParser

struct BlockDirectiveView<InlineMarkupContent: InlineMarkupContentViewProtocol>: View {
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
          MarkupContentView<InlineMarkupContent>(content: child, listDepth: listDepth, isNested: true)
        }
      }
      SwiftUI.Text("}")
    }
  }
}
