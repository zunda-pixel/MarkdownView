//
//  MarkupContentView.swift
//

import Algorithms
import MarkdownUIParser
import SwiftUI

public struct MarkupContentView: View {
  public let content: MarkupContent
  public let listDepth: Int
  public let unOrderedMark: [Int: String]
  public let headingFonts: [Int: Font]

  public static let defaultUnOrderedMark: [Int: String] = [
    0: "•",
    1: "◦",
    2: "▫︎",
  ]

  public static let defaultHeadingFonts: [Int: Font] = [
    1: .title,
    2: .title2,
    3: .title3,
  ]

  public init(
    content: MarkupContent,
    listDepth: Int,
    unOrderedMark: [Int: String] = defaultUnOrderedMark,
    headingFonts: [Int: Font] = defaultHeadingFonts
  ) {
    self.content = content
    self.listDepth = listDepth
    self.unOrderedMark = unOrderedMark
    self.headingFonts = headingFonts
  }

  public var body: some View {
    switch content {
    case .text(let text):
      Text(text)
    case .thematicBreak:
      Divider()
    case .blockDirective(let name, let arguments, let children):
      VStack(alignment: .leading, spacing: 0) {
        Text("@\(name)(\(arguments.joined())) {")
        ForEach(children.indexed(), id: \.index) { _, child in
          HStack(alignment: .center, spacing: 0) {
            Spacer().frame(maxWidth: 10)
            MarkupContentView(content: child, listDepth: listDepth)
          }
        }
        Text("}")
      }
    case .htmlBlock(let text):
      Text(text)
    case .codeBlock(let language, let sourceCode):
      CodeBlockView(language: language, sourceCode: sourceCode)
    case .link(let destination, let children):
      if let destination,
         let url = URL(string: destination)
      {
        Link(destination: url) {
          FlowLayout {
            ForEach(children.indexed(), id: \.index) { _, content in
              InlineMarkupContentView(content: content)
            }
          }
        }
      } else {
        FlowLayout {
          ForEach(children.indexed(), id: \.index) { _, content in
            InlineMarkupContentView(content: content)
          }
        }
      }
    case .heading(let level, let children):
      FlowLayout {
        ForEach(children.indexed(), id: \.index) { _, content in
          InlineMarkupContentView(content: content)
        }
      }
      .bold()
      .ifLet(headingFonts[level]) { view, font in
        view.font(font)
      }
    case .paragraph(let children):
      FlowLayout {
        ForEach(children.indexed(), id: \.index) { _, content in
          InlineMarkupContentView(content: content)
        }
      }
    case .blockQuote(let kind, let blockChildren):
      VStack(alignment: .leading, spacing: 10) {
        if let label = kind.label {
          Label(label.0, systemImage: label.1)
            .foregroundStyle(label.2)
        }
        
        ForEach(blockChildren.indexed(), id: \.index) { _, blockChild in
          ForEach(blockChild.split(separator: .softBreak).indexed(), id: \.index) { _, children in
            // TODO HStackでは長文に対応できない
            HStack(alignment: .center, spacing: 0) {
              ForEach(children.indexed(), id: \.index) { _, child in
                MarkupContentView(content: child, listDepth: listDepth)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .foregroundStyle(.secondary)
      .padding(10)
      .border(.secondary)
    case .orderedList(let items):
      VStack(alignment: .leading, spacing: 10) {
        ForEach(items.indexed(), id: \.index) { index, item in
          HStack(alignment: .center, spacing: 5) {
            Text("\(index + 1).")
            ForEach(item.children.indexed(), id: \.index) { _, child in
              MarkupContentView(content: child, listDepth: listDepth)
            }
          }
        }
      }
    case .unorderedList(let items):
      VStack(alignment: .leading, spacing: 10) {
        ForEach(items.indexed(), id: \.index) { _, item in
          VStack(alignment: .leading, spacing: 10) {
            ForEach(item.children.indexed(), id: \.index) { _, child in
              HStack(alignment: .center, spacing: 10) {
                if case .unorderedList(_) = child {
                  Spacer().frame(width: 10)
                } else {
                  if let checkbox = item.checkbox {
                    Image(systemName: checkbox == .checked ? "checkmark.square" : "square")
                  } else {
                    Text(unOrderedMark[listDepth] ?? unOrderedMark[unOrderedMark.count - 1]!)
                  }
                }

                MarkupContentView(content: child, listDepth: listDepth + 1)
              }
            }
          }
        }
      }
    case .table(let headItems, let bodyItems):
      TableView(headItems: headItems, bodyItems: bodyItems)
    case .softBreak:
      EmptyView()  // TODO
    }
  }
}

extension View {
  @ViewBuilder
  fileprivate func ifLet<Value, Content: View>(
    _ value: Value?,
    @ViewBuilder content: (Self, Value) -> Content
  ) -> some View {
    if let value {
      content(self, value)
    } else {
      self
    }
  }
}

#Preview {
  MarkdownView(document: .init(parsing: """
> Title1
> Title2
> Title3 Title3Title3Title3Title3Title3Titijijijjijijijijijijijijijijijijijijle3[Link](https://google.com) dfsfsdfs
"""))
}

#Preview{
  let items: [MarkupContent] = [
    .blockQuote(
      kind: .attention,
      children: [
        [
          .text(text: "Hello"),
        ],
      ]
    ),
    .blockDirective(
      name: "area",
      arguments: ["x: Int, y: Int"],
      children: [
        .text(text: "let are = x * y"),
        .text(text: "return area"),
      ]
    ),
    .heading(level: 1, children: [.text(text: "Title1")]),
    .heading(level: 2, children: [.text(text: "Title2")]),
    .heading(level: 3, children: [.text(text: "Title3")]),
    .heading(level: 4, children: [.text(text: "Title4")]),
    .text(text: "Title5"),
    .codeBlock(
      language: "swift:  Sample.swift  ",
      sourceCode: """
        import Foundation
        print("Hello")
        """),
    .orderedList(items: [
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item1")
        ]
      ),
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item2"),
        ]
      ),
      .init(
        checkbox: nil,
        children: [
          .text(text: "Item3")
        ]
      ),
    ]),
    .unorderedList(
      items: [
        .init(
          checkbox: nil,
          children: [.text(text: "Item1")]
        ),
        .init(
          checkbox: nil,
          children: [
            .text(text: "Item2"),
            .unorderedList(
              items: [
                .init(
                  checkbox: nil,
                  children: [
                    .text(text: "Item3-1"),
                    .unorderedList(
                      items: [
                        .init(
                          checkbox: nil,
                          children: [.text(text: "Item4"),]
                        ),
                      ]
                    ),
                    .text(text: "Item3-2"),
                  ]
                ),
              ]
            )
          ]
        ),
        .init(
          checkbox: nil,
          children: [.text(text: "Item5")]
        ),
      ]
    ),
    .unorderedList(items: [
      .init(
        checkbox: .checked,
        children: [.text(text: "Item1")]
      ),
      .init(
        checkbox: .unchecked,
        children: [.text(text: "Item2")]
      ),
      .init(
        checkbox: .checked,
        children: [.text(text: "Item3")]
      ),
    ]),
  ]

  return ScrollView {
    VStack(alignment: .leading, spacing: 10) {
      ForEach(items.indexed(), id: \.index) { _, item in
        MarkupContentView(content: item, listDepth: 0)
        Divider()
      }
    }
  }
  .padding(10)
}

extension BlockQuoteKind {
  var label: (String, String, Color)? {
    switch self {
    case .note: return nil
    case .tip: return("Tip", "lightbulb", .yellow)
    case .important: return ("Important", "exclamationmark.circle", .orange)
    case .experiment: return ("Experiment", "flame", .red)
    case .warning: return ("Warning", "exclamationmark.triangle", .orange)
    case .attention: return ("Attention", "exclamationmark.circle", .red)
    case .author: return ("Author", "pencil", .blue)
    case .authors: return ("Authors", "square.and.pencil", .blue)
    case .bug: return("Bug", "hammer", .red)
    case .complexity: return ("Complexity", "chart.bar.xaxis", .purple)
    case .copyright: return ("Copyright", "info.circle", .gray)
    case .date: return("Date", "calendar", .green)
    case .invariant: return("Invariant", "arrow.up.left.and.arrow.down.right.circle", .blue)
    case .mutatingVariant: return ("Mutating Variant", "arrow.triangle.turn.up.right.diamond.fill", .red)
    case .nonMutatingVariant: return ("Non Mutating Variant", "arrow.triangle.turn.up.right.diamond", .gray)
    case .postcondition: return ("Post Condition", "arrow.right.circle", .green)
    case .precondition: return ("Pre Condition", "arrow.left.circle", .gray)
    case .remark: return ("Remark", "quote.bubble", .gray)
    case .requires: return ("Requires", "arrow.right.to.line.alt", .green)
    case .since: return ("Since", "clock", .green)
    case .toDo: return ("ToDo", "checkmark.circle", .green)
    case .version: return ("Version", "square.and.arrow.up", .blue)
    case .throws: return ("Throws", "exclamationmark.octagon", .orange)
    case .seeAlso: return ("See Also", "arrow.right.doc.on.clipboard", .blue)
    }
  }
}

#Preview {
  List {
    ForEach(BlockQuoteKind.allCases, id: \.self) { kind in
      let content = MarkupContent.blockQuote(kind: kind, children: [
        [
          .text(text: kind.rawValue)
        ],
      ])
      MarkupContentView(content: content, listDepth: 0)
    }
  }
  .frame(width: 300, height: 580)
}

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
