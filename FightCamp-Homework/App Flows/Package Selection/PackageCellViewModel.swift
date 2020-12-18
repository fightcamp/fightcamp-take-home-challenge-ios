import Foundation
import UIKit

class PackageCellViewModel: CellItem {
  let thumbnailVms: [PackageThumbnailViewModel]
  let title: NSAttributedString
  let description: NSAttributedString
  let priceInterval: String
  let equipmentAttributedString: NSAttributedString
  let price: String
  var selectedIndex: Int = 0
  
  private let package: Package
  
  required init(package: Package) {
    self.package = package
    self.thumbnailVms = package.thumbnail_urls?.compactMap({PackageThumbnailViewModel(imageUrl: $0)}) ?? []
    
    self.title = NSAttributedString(
      string: package.title.uppercased(),
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.brandRed,
        NSAttributedString.Key.font: UIFont.title
      ])
    
    self.description = NSAttributedString(
      string: package.desc.capitalized,
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.label,
        NSAttributedString.Key.font: UIFont.body
      ])
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 8
    
    let equipmentString = NSMutableAttributedString()
    let includedString = package.included?.joined(separator: "\n") ?? ""
    equipmentString.append(NSAttributedString(string: includedString.capitalized, attributes: [
      NSAttributedString.Key.foregroundColor: UIColor.label,
      NSAttributedString.Key.font: UIFont.body,
      NSAttributedString.Key.paragraphStyle: paragraphStyle
    ]))
    
    if let excludedItems = package.excluded {
      // separate included and excluded
      equipmentString.append(NSAttributedString(string: "\n"))
      
      let excludedString = excludedItems.joined(separator: "\n")
      equipmentString.append(NSAttributedString(string: excludedString.capitalized, attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.disabledLabel,
        NSAttributedString.Key.font: UIFont.body,
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
        NSAttributedString.Key.strikethroughColor: UIColor.disabledLabel
      ]))
    }
    
    self.equipmentAttributedString = equipmentString
    
    self.priceInterval = package.payment.capitalized
    self.price = "$\(package.price)"
    super.init(id: package.title)
  }
  
  func selectThumbnailIndex(_ index: Int) {
    selectedIndex = index
  }
}
