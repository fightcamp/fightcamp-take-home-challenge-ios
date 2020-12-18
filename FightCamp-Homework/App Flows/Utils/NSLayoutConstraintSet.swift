import Foundation
import UIKit

class NSLayoutConstraintSet {
  
  internal var top: NSLayoutConstraint?
  internal var bottom: NSLayoutConstraint?
  internal var left: NSLayoutConstraint?
  internal var right: NSLayoutConstraint?
  internal var centerX: NSLayoutConstraint?
  internal var centerY: NSLayoutConstraint?
  internal var width: NSLayoutConstraint?
  internal var height: NSLayoutConstraint?
  
  internal init(top: NSLayoutConstraint? = nil, bottom: NSLayoutConstraint? = nil,
                left: NSLayoutConstraint? = nil, right: NSLayoutConstraint? = nil,
                centerX: NSLayoutConstraint? = nil, centerY: NSLayoutConstraint? = nil,
                width: NSLayoutConstraint? = nil, height: NSLayoutConstraint? = nil) {
    self.top = top
    self.bottom = bottom
    self.left = left
    self.right = right
    self.centerX = centerX
    self.centerY = centerY
    self.width = width
    self.height = height
  }
  
  /// All of the currently configured constraints
  private var availableConstraints: [NSLayoutConstraint] {
    let constraints = [top, bottom, left, right, centerX, centerY, width, height]
    var available: [NSLayoutConstraint] = []
    for constraint in constraints {
      if let value = constraint {
        available.append(value)
      }
    }
    return available
  }
  
  /// Activates all of the non-nil constraints
  ///
  /// - Returns: Self
  @discardableResult
  internal func activate() -> Self {
    NSLayoutConstraint.activate(availableConstraints)
    return self
  }
  
  /// Deactivates all of the non-nil constraints
  ///
  /// - Returns: Self
  @discardableResult
  internal func deactivate() -> Self {
    NSLayoutConstraint.deactivate(availableConstraints)
    return self
  }
}
