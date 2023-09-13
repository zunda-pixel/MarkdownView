//
//  ListDepthKey.swift
//

import SwiftUI

public struct ListDepthKey: EnvironmentKey {
  static public var defaultValue: UInt = 0
}

public extension EnvironmentValues {
  var listDepth: UInt {
    get { return self[ListDepthKey.self] }
    set { self[ListDepthKey.self] = newValue }
  }
}
