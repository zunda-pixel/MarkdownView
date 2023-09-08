//
//  InlineCodeView.swift
//

import SwiftUI

struct InlineCodeView: View {
  let code: String

  var body: some View {
    Text(code)
      .padding(.vertical, 2)
      .padding(.horizontal, 4)
      .background {
        RoundedRectangle(cornerRadius: 8)
          .foregroundStyle(.secondary.opacity(0.2))
      }
  }
}

#Preview {
  InlineCodeView(code: "Hello,, World!")
}
