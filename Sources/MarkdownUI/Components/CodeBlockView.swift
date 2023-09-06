//
//  CodeBlockView.swift
//

import SwiftUI

struct CodeBlockView: View {
  let language: String?
  let sourceCode: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if let fileName = language?.split(separator: ":")[safe: 1] {
        Text(fileName.trimming(while: \.isWhitespace))
          .padding(.horizontal, 5)
          .padding(.vertical, 2)
          .foregroundStyle(.background)
          .background {
            CustomRoundedRectangle(
              topLeftRadius: 8,
              topRightRadius: 8,
              bottomLeftRadius: 0,
              bottomRightRadius: 0
            )
            .foregroundStyle(.foreground.opacity(0.5))
          }
      }
      Text(sourceCode)
        .fixedSize(horizontal: true, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .foregroundStyle(.background)
        .background {
          CustomRoundedRectangle(
            topLeftRadius: 0,
            topRightRadius: 8,
            bottomLeftRadius: 8,
            bottomRightRadius: 8
          )
            .foregroundStyle(.foreground)
        }
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
