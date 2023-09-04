//
//  ListItemContent.swift
//

import Foundation
import Markdown

public struct ListItemContent: Hashable, Sendable {
  public let checkbox: Checkbox?
  public let children: [MarkupContent]
  
  public init(
    checkbox: Checkbox?,
    children: [MarkupContent]
  ) {
    self.checkbox = checkbox
    self.children = children
  }
}

extension Checkbox: @unchecked Sendable {
  
}
