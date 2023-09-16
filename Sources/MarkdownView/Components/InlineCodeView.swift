//
//  InlineCodeView.swift
//

import SwiftUI

public struct InlineCodeView: View {
  public let code: String

  public init(code: String) {
    self.code = code
  }

  public var body: some View {
    Text(code)
      .padding(.vertical, 2)
      .padding(.horizontal, 4)
      .background(
        .regularMaterial,
        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
      )
  }
}

#Preview {
  InlineCodeView(code: "Hello,, World!")
}
