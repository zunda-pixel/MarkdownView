//
//  BlockQuoteKind.swift
//

import Foundation
import Markdown

public enum BlockQuoteKind: String, Sendable, Hashable {
  case note = "Note"
  case tip = "Tip"
  case important = "Important"
  case experiment = "Experiment"
  case warning = "Warning"
  case attention = "Attention"
  case author = "Author"
  case authors = "Authors"
  case bug = "Bug"
  case complexity = "Complexity"
  case copyright = "Copyright"
  case date = "Date"
  case invariant = "Invariant"
  case mutatingVariant = "MutatingVariant"
  case nonMutatingVariant = "NonMutatingVariant"
  case postcondition = "Postcondition"
  case precondition = "Precondition"
  case remark = "Remark"
  case requires = "Requires"
  case since = "Since"
  case toDo = "ToDo"
  case version = "Version"
  case `throws` = "Throws"
  case seeAlso = "SeeAlso"
  
  init(kind: Aside.Kind) {
    self.init(rawValue: kind.rawValue)!
  }
}
