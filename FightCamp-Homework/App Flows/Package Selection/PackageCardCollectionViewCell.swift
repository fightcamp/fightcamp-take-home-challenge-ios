import Foundation
import UIKit

//struct PackageCardCollectionViewModel: CellItem{
//  let package: Package
//}

class PackageCardCollectionViewCell: UICollectionViewCell {
  
  var viewModel: PackageCellViewModel? {
    didSet {
      titleLabel.attributedText = viewModel?.title
      descriptionLabel.attributedText = viewModel?.description
    }
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(imageView)
    return imageView
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    
    contentView.backgroundColor = UIColor.white
    contentView.layer.cornerRadius = CGFloat.packageRadius
    contentView.clipsToBounds = true
    
    NSLayoutConstraintSet(
      top: titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat.packageSpacing),
      left: titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: CGFloat.packageSpacing),
      right: titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: CGFloat.packageSpacing)
    ).activate()
    
    NSLayoutConstraintSet(
      top: descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      left: descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0)
    ).activate()
    
    NSLayoutConstraintSet(
      top: thumbnailImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      bottom: thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
      left: thumbnailImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: thumbnailImageView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0),
      height: thumbnailImageView.heightAnchor.constraint(equalToConstant: 600)
    ).activate()
  }
}
