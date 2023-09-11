//
//  DoxygenReturnsView.swift
//

import SwiftUI

public struct DoxygenReturnsView: View {
  public let children: [MarkupContent]
  public let listDepth: Int
  
  public init(
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.children = children
    self.listDepth = listDepth
  }
  
  public var body: some View {
    FlowLayout {
      SwiftUI.Text("\\returns")
      ForEach(children.indexed(), id: \.index) { _, child in
        MarkupContentView(content: child, listDepth: listDepth, isNested: true)
      }
    }
  }
}
