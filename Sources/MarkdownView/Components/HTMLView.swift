//
//  HTMLView.swift
//

import SwiftUI

public struct HTMLView: View {
  public let html: String
  public let failure: (String) -> AttributedString

  public init(
    html: String,
    failure: @escaping (String) -> AttributedString = { AttributedString($0) }
  ) {
    self.html = html
    self.failure = failure
  }

  var attributedString: AttributedString {
    let data = Data(html.utf8)

    let nsAttributedString = try? NSAttributedString(
      data: data,
      options: [.documentType: NSAttributedString.DocumentType.html],
      documentAttributes: nil
    )

    let attributedString = nsAttributedString.map { AttributedString($0) } ?? failure(html)

    return attributedString
  }

  public var body: some View {
    Text(attributedString)
  }
}

#Preview {
  let html = """
    <html>
    <body>
    <h1>Hello, world!</h1>
    </body>
    </html>
    """

  return HTMLView(html: html)
}
