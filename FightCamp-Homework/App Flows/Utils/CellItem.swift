import Foundation
import UIKit

/// Base class to represent a diffable CollectionView ViewModel
class CellItem: Hashable {
  
  let id: String
  
  init(id: String) {
    self.id = id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: CellItem, rhs: CellItem) -> Bool {
    return lhs.id == rhs.id
  }
}
