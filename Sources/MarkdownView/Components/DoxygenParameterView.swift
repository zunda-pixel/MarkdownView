//
//  DoxygenParameterView.swift
//

import SwiftUI

public struct DoxygenParameterView: View {
  public let name: String
  public let children: [MarkupContent]
  public let listDepth: Int
  
  public init(
    name: String,
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.name = name
    self.children = children
    self.listDepth = listDepth
  }
  
  public var body: some View {
    FlowLayout {
      SwiftUI.Text("\\param \(name)")
      ForEach(children.indexed(), id: \.index) { _, child in
        MarkupContentView(content: child, listDepth: listDepth, isNested: true)
      }
    }
  }
}
