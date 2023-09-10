//
//  MarkupContent.swift
//

import Foundation

public enum MarkupContent: Hashable, Sendable {
  case text(text: String)
  case codeBlock(language: String?, sourceCode: String)
  case link(destination: String?, children: [InlineMarkupContent])
  case heading(level: Int, children: [InlineMarkupContent])
  case paragraph(children: [InlineMarkupContent])
  case blockQuote(kind: BlockQuoteKind, children: [[MarkupContent]])
  case softBreak
  case orderedList(items: [ListItemContent])
  case unorderedList(items: [ListItemContent])
  case table(head: [InlineMarkupContent], body: [[[InlineMarkupContent]]])
  case htmlBlock(text: String)
  case thematicBreak
  case blockDirective(name: String, arguments: [Substring], children: [MarkupContent])
  case doxygenParameter(name: String, children: [MarkupContent])
  case doxygenReturns(children: [MarkupContent])
  case emphasis(children: [InlineMarkupContent])
  case strong(children: [InlineMarkupContent])
  case strikethrough(children: [InlineMarkupContent])
  case inlineCode(code: String)
}
