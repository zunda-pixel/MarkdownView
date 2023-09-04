//
//  ListItemContent.swift
//

import Foundation
import Markdown

struct ListItemContent: Hashable {
  let checkbox: Checkbox?
  let children: [MarkupContent]
}
