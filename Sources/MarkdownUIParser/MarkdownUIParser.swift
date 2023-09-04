//
//  MarkdownUIParser.swift
//

import Foundation
import Markdown

public enum MarkdownUIParser {
  public static func parse(document: Document) -> [MarkupContent] {
    document.children.map {
      markupContent(markup: $0)
    }
  }

  public static func inlineMarkupContent(
    markup: some Markdown.InlineMarkup
  ) -> InlineMarkupContent {
    switch markup {
    case let image as Markdown.Image:
      return .image(title: image.plainText, source: image.source)
    case let text as Markdown.Text:
      return .text(text: text.string)
    case _ as Markdown.SoftBreak:
      return .softBreak
    case let link as Markdown.Link:
      let children = link.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .link(destination: link.destination, children: Array(children))
    case let strong as Markdown.Strong:
      let children = strong.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .strong(children: Array(children))
    case let strikethrough as Markdown.Strikethrough:
      let children = strikethrough.inlineChildren.map {
        inlineMarkupContent(markup: $0)
      }
      return .strikethrough(children: Array(children))
    case let emphasis as Markdown.Emphasis:
      let children = emphasis.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .strong(children: Array(children))
    case let inlineCode as Markdown.InlineCode:
      return .inlineCode(code: inlineCode.code)
    default:
      print("Error inlineMarkupContent")
      print(type(of: markup))
      print(markup.debugDescription())
      fatalError()
    }
  }

  public static func markupContent(markup: some Markdown.Markup) -> MarkupContent {
    switch markup {
    case let link as Markdown.Link:
      let children = link.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .link(destination: link.destination, children: Array(children))
    case let heading as Markdown.Heading:
      let children = heading.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .heading(level: heading.level, children: Array(children))
    case let blockQuote as Markdown.BlockQuote:
      let children = blockQuote.blockChildren.map { blockChild in
        blockChild.children.map { markupContent(markup: $0) }
      }
      return .blockQuote(children: Array(children))
    case let paragraph as Markdown.Paragraph:
      let children = paragraph.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .paragraph(children: Array(children))
    case let text as Markdown.Text:
      return .text(text: text.string)
    case _ as Markdown.SoftBreak:
      return .softBreak
    case let orderedList as Markdown.OrderedList:
      let items = orderedList.listItems.map { item in
        let children = item.children.map {
          markupContent(markup: $0)
        }
        return ListItemContent(checkbox: item.checkbox, children: children)
      }
      return .orderedList(items: Array(items))
    case let unorderedList as Markdown.UnorderedList:
      let items = unorderedList.listItems.map { item in
        let children = item.children.map { markupContent(markup: $0) }
        return ListItemContent(checkbox: item.checkbox, children: children)
      }
      return .unorderedList(items: Array(items))
    case let table as Markdown.Table:
      let head = table.children.first { $0 is Markdown.Table.Head }! as! Markdown.Table.Head
      let bodies = table.children.compactMap { $0 as? Markdown.Table.Body }

      let headItems: [InlineMarkupContent] = head.children.reduce(into: []) { result, child in
        let cell = child as! Markdown.Table.Cell
        for child in cell.inlineChildren {
          result.append(inlineMarkupContent(markup: child))
        }
      }

      let bodyItems: [[[InlineMarkupContent]]] = bodies.reduce(into: []) { result, head in
        for child in bodies.flatMap(\.children) {
          if let row = child as? Markdown.Table.Row {
            let cells: [[InlineMarkupContent]] = row.children.reduce(into: []) { cells, child in
              let cell = child as! Markdown.Table.Cell
              cells.append(
                cell.inlineChildren.map {
                  inlineMarkupContent(markup: $0)
                })
            }
            result.append(cells)
          }
        }
      }

      return .table(headItems: headItems, bodyItems: bodyItems)
    case let codeBlock as Markdown.CodeBlock:
      return .codeBlock(language: codeBlock.language, sourceCode: codeBlock.code)
    case let htmlBlock as Markdown.HTMLBlock:
      return .htmlBlock(text: htmlBlock.rawHTML)
    default:
      print("Error markupContent")
      print(type(of: markup))
      print(markup.debugDescription().description)
      fatalError()
    }
  }
}
