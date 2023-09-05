//
//  InlineMarkupContent.swift
//

import Foundation

public enum InlineMarkupContent: Hashable, Sendable {
  case image(title: String, source: String?)
  case text(text: String)
  case softBreak
  case link(destination: String?, children: [InlineMarkupContent]?)
  case strong(children: [InlineMarkupContent])
  case strikethrough(children: [InlineMarkupContent])
  case emphasis(children: [InlineMarkupContent])
  case inlineCode(code: String)
  case inlineHTML(html: String)
  case symbolLink(destination: String?)
  case inlineAttributes(attributes: String, children: [InlineMarkupContent])
}
