//
//  MarkdownView.swift
//

import Markdown
import SwiftUI

public struct MarkdownView: View {
  public let document: Document

  public init(document: Document) {
    self.document = document
  }

  var contents: [MarkupContent] {
    MarkdownViewParser.parse(document: document)
  }

  public var body: some View {
    ForEach(contents, id: \.self) { content in
      MarkupContentView(content: content)
    }
  }
}

#Preview {
  let source = """
    # Title1

    Content1

    ## Title2

    ### Title3

    #### Title4

    ##### Title5

    *italic*
    **bold**
    ~~strikethrough~~
    `code`

    > Text that is a `quote`
    > Text that is a `quote`

    > Tip: Tip Description
    > Tip Description

    > Attention: Attention Description
    > Attention Description

    ```swift: Sample.swift
    import Foundation

    print("hello")
    ```

    ![GitHub Logo](https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png)


    | Head | Head | Head |
    | ---- | ---- | ---- |
    | Text | Text | Text |
    | Text | Text | Text |

    1. First list item
    23. Second list item
    34. Third list item

    - First nested list item
    - Second nested list item

    1. First list item
       - First nested list item
         - Second nested list item

    ## Doxygen Documentation

    ### Parameters

    \\param string The input Markdown text to parse.
    \\param source An explicit source URL from which the input string came for marking source locations. This need not be a file URL.
    \\param options Options for parsing Markdown text.

    ### Returns

    \\returns A markup element representing the top level of a whole document.

    \\note Although this could be considered a block element that can contain block elements, a `Document` itself can't be the child of any other markup, so it is not considered a block element.

    \\discussion This object can give other objects in your program magical powers.
    """

  let document = Document(
    parsing: source,
    options: [
      .parseBlockDirectives,
      .parseMinimalDoxygen,
      .parseSymbolLinks,
    ]
  )

  return ScrollView {
    LazyVStack(alignment: .leading, spacing: 10) {
      MarkdownView(document: document)
    }
    .padding(10)
  }
}
