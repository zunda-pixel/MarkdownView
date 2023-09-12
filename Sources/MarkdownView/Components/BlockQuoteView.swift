//
//  BlockQuoteView.swift
//

import Markdown
import SwiftUI

public struct BlockQuoteView: View {
  public let kind: Aside.Kind
  public let children: [MarkupContent]
  public let listDepth: Int

  public init(
    kind: Aside.Kind,
    children: [MarkupContent],
    listDepth: Int
  ) {
    self.kind = kind
    self.children = children
    self.listDepth = listDepth
  }

  public var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Rectangle()
        .fill(kind.label?.2 ?? .secondary)
        .frame(width: 2)

      VStack(alignment: .leading, spacing: 10) {
        if let label = kind.label {
          Label(label.0, systemImage: label.1)
            .foregroundStyle(label.2)
        }

        ForEach(children.indexed(), id: \.index) { _, child in
          MarkupContentView(content: child, listDepth: listDepth)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(.secondary)
    }
  }
}

extension Aside.Kind {
  fileprivate var label: (String, String, Color)? {
    switch self {
    case .note: return nil
    case .tip: return ("Tip", "lightbulb", .yellow)
    case .important: return ("Important", "exclamationmark.circle", .orange)
    case .experiment: return ("Experiment", "flame", .red)
    case .warning: return ("Warning", "exclamationmark.triangle", .orange)
    case .attention: return ("Attention", "exclamationmark.circle", .red)
    case .author: return ("Author", "pencil", .blue)
    case .authors: return ("Authors", "square.and.pencil", .blue)
    case .bug: return ("Bug", "hammer", .red)
    case .complexity: return ("Complexity", "chart.bar.xaxis", .purple)
    case .copyright: return ("Copyright", "info.circle", .gray)
    case .date: return ("Date", "calendar", .green)
    case .invariant: return ("Invariant", "arrow.up.left.and.arrow.down.right.circle", .blue)
    case .mutatingVariant:
      return ("Mutating Variant", "arrow.triangle.turn.up.right.diamond.fill", .red)
    case .nonMutatingVariant:
      return ("Non Mutating Variant", "arrow.triangle.turn.up.right.diamond", .gray)
    case .postcondition: return ("Post Condition", "arrow.right.circle", .green)
    case .precondition: return ("Pre Condition", "arrow.left.circle", .gray)
    case .remark: return ("Remark", "quote.bubble", .gray)
    case .requires: return ("Requires", "arrow.right.to.line.alt", .green)
    case .since: return ("Since", "clock", .green)
    case .todo: return ("ToDo", "checkmark.circle", .green)
    case .version: return ("Version", "square.and.arrow.up", .blue)
    case .throws: return ("Throws", "exclamationmark.octagon", .orange)
    case .seeAlso: return ("See Also", "arrow.right.doc.on.clipboard", .blue)
    default: return nil
    }
  }
}

#Preview{
  ScrollView {
    VStack(spacing: 10) {
      ForEach(Aside.Kind.allCases, id: \.self) { kind in
        let blockQuote: MarkupContent = .blockQuote(
          kind: kind,
          children: [
            .text(text: kind.rawValue)
          ])
        MarkupContentView(content: blockQuote, listDepth: 0)
      }
    }
    .padding(10)
  }
  .frame(width: 300, height: 580)
}
