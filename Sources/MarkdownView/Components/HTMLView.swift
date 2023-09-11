//
//  HTMLView.swift
//

import SwiftUI

public struct HTMLView: View {
  public let html: String
  
  public init(html: String) {
    self.html = html
  }
  
  var attributedString: AttributedString {
    let data = Data(html.utf8)
    
    let attributedString = try! NSAttributedString(
      data: data,
      options: [.documentType: NSAttributedString.DocumentType.html],
      documentAttributes: nil
    )
    
    return AttributedString(attributedString)
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
