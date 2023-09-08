//
//  InlineMarkupContentViewProtocol.swift
//

import SwiftUI
import MarkdownViewParser

public protocol InlineMarkupContentViewProtocol: View {
  init(content: InlineMarkupContent)
}
