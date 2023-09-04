//
//  MarkupContent.swift
//

import Foundation

enum MarkupContent: Hashable, Sendable {
  case text(text: String)
  case codeBlock(language: String?, sourceCode: String)
  case link(destination: String?, children: [InlineMarkupContent])
  case heading(level: Int, children: [InlineMarkupContent])
  case paragraph(children: [InlineMarkupContent])
  case blockQuote(children: [[MarkupContent]])
  case softBreak
  case orderedList(items: [ListItemContent])
  case unorderedList(items: [ListItemContent])
  case table(headItems: [InlineMarkupContent], bodyItems: [[[InlineMarkupContent]]])
  case htmlBlock(text: String)
}
