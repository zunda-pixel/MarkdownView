//
//  MarkdownViewParser.swift
//

import Foundation
import Markdown

public enum MarkdownViewParser {
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
    case let inlineAttributes as Markdown.InlineAttributes:
      let children = inlineAttributes.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .inlineAttributes(attributes: inlineAttributes.attributes, children: Array(children))
    case let symbolLink as Markdown.SymbolLink:
      return .symbolLink(destination: symbolLink.destination)
    case let inlineHTML as Markdown.InlineHTML:
      return .inlineHTML(html: inlineHTML.rawHTML)
    case _ as Markdown.SoftBreak:
      return .softBreak
    case _ as Markdown.LineBreak:
      return .lineBreak
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
      return .emphasis(children: Array(children))
    case let inlineCode as Markdown.InlineCode:
      return .inlineCode(code: inlineCode.code)
    default:
      fatalError()
    }
  }

  public static func markupContent(markup: some Markdown.Markup) -> MarkupContent {
    switch markup {
    case let inlineCode as Markdown.InlineCode:
      return .inlineCode(code: inlineCode.code)
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
      return .emphasis(children: Array(children))
    case let link as Markdown.Link:
      let children = link.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .link(destination: link.destination, children: Array(children))
    case let doxygenParameter as Markdown.DoxygenParameter:
      let children = doxygenParameter.children.map { markupContent(markup: $0) }
      return .doxygenParameter(name: doxygenParameter.name, children: children)
    case let doxygenReturns as Markdown.DoxygenReturns:
      let children = doxygenReturns.children.map { markupContent(markup: $0) }
      return .doxygenReturns(children: children)
    case let blockDirective as Markdown.BlockDirective:
      let arguments = blockDirective.argumentText.segments.map { $0.trimmedText }
      let children = blockDirective.blockChildren.map { markupContent(markup: $0) }
      return .blockDirective(name: blockDirective.name, arguments: arguments, children: Array(children))
    case _ as Markdown.ThematicBreak:
      return .thematicBreak
    case let heading as Markdown.Heading:
      let children = heading.inlineChildren.map { inlineMarkupContent(markup: $0) }
      return .heading(level: heading.level, children: Array(children))
    case let blockQuote as Markdown.BlockQuote:
      let aside = Aside(blockQuote)
      let children = aside.content.map { blockChild in
        blockChild.children.map { markupContent(markup: $0) }
      }
      return .blockQuote(kind: aside.kind, children: children)
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

      return .table(head: headItems, body: bodyItems)
    case let codeBlock as Markdown.CodeBlock:
      return .codeBlock(language: codeBlock.language, sourceCode: codeBlock.code)
    case let htmlBlock as Markdown.HTMLBlock:
      return .htmlBlock(text: htmlBlock.rawHTML)
    default:
      fatalError()
    }
  }
}
