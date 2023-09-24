//
//  View++.swift
//

import SwiftUI

extension View {
  @ViewBuilder
  func ifLet<Value, Content: View>(
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
