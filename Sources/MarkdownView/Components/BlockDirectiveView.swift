//
//  BlockDirectiveView.swift
//

import SwiftUI
import MarkdownViewParser

public struct BlockDirectiveView<InlineMarkupContentView: InlineMarkupContentViewProtocol>: View {
  public let name: String
  public let arguments: [Substring]
  public let children: [MarkupContent]
  public let listDepth: Int
  
  public init(
    name: String,
    arguments: [Substring],
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.name = name
    self.arguments = arguments
    self.children = children
    self.listDepth = listDepth
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      SwiftUI.Text("@\(name)(\(arguments.joined())) {")
      ForEach(children.indexed(), id: \.index) { _, child in
        HStack(alignment: .center, spacing: 0) {
          Spacer().frame(maxWidth: 10)
          MarkupContentView<InlineMarkupContentView>(content: child, listDepth: listDepth, isNested: true)
        }
      }
      SwiftUI.Text("}")
    }
  }
}
