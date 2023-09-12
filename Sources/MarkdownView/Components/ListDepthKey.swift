//
//  ListDepthKey.swift
//

import SwiftUI

struct ListDepthKey: EnvironmentKey {
  static var defaultValue: UInt = 0
}

extension EnvironmentValues {
  var listDepth: UInt {
    get { return self[ListDepthKey.self] }
    set { self[ListDepthKey.self] = newValue }
  }
}
