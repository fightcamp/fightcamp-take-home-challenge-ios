import Foundation
import UIKit

class PackageCardCollectionViewCell: UICollectionViewCell {
  static let ThumbnailCollectionHeight: CGFloat = 75
  
  var viewModel: PackageCellViewModel? {
    didSet {
      guard let vm = viewModel else {
        return
      }
      
      titleLabel.attributedText = vm.title
      descriptionLabel.attributedText = vm.description
      equipmentLabel.attributedText = vm.equipmentAttributedString
      equipmentLabel.numberOfLines = 0
      priceIntervalLabel.text = vm.priceInterval
      priceIntervalLabel.font = UIFont.body
      
      priceAmountLabel.text = vm.price
      priceAmountLabel.font = UIFont.price
      
      viewPackageButton.setTitle("View Package", for: UIControl.State.normal)
      viewPackageButton.backgroundColor = UIColor.brandRed
      viewPackageButton.titleLabel?.font = UIFont.button
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
  
  private lazy var currentThumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(imageView)
    return imageView
  }()
  
  private lazy var equipmentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var priceIntervalLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var priceAmountLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private lazy var viewPackageButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = CGFloat.buttonRadius
    button.clipsToBounds = true
    self.contentView.addSubview(button)
    return button
  }()
  
  private lazy var thumbnailsCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let thumbnailsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    thumbnailsCollectionView.showsHorizontalScrollIndicator = false
    thumbnailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    thumbnailsCollectionView.backgroundColor = UIColor.primaryBackground
    self.contentView.addSubview(thumbnailsCollectionView)
    return thumbnailsCollectionView
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
    
    // set up collection view
    thumbnailsCollectionView.register(PackageThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PackageThumbnailCollectionViewCell.self))
    
    contentView.backgroundColor = UIColor.white
    contentView.layer.cornerRadius = CGFloat.packageRadius
    contentView.clipsToBounds = true
    
    NSLayoutConstraintSet(
      top: titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat.packageSpacing),
      left: titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: CGFloat.packageSpacing),
      right: titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -CGFloat.packageSpacing)
    ).activate()
    
    NSLayoutConstraintSet(
      top: descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      left: descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0)
    ).activate()
    
    NSLayoutConstraintSet(
      top: currentThumbnailImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      left: currentThumbnailImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: currentThumbnailImageView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0),
      height: currentThumbnailImageView.heightAnchor.constraint(equalToConstant: CGFloat.thumbnailHeight)
    ).activate()
    
    NSLayoutConstraintSet(
      top: thumbnailsCollectionView.topAnchor.constraint(equalTo: currentThumbnailImageView.bottomAnchor, constant: CGFloat.packageSpacing),
      left: thumbnailsCollectionView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: thumbnailsCollectionView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0),
      height: thumbnailsCollectionView.heightAnchor.constraint(equalToConstant: PackageCardCollectionViewCell.ThumbnailCollectionHeight)
    ).activate()
    
    NSLayoutConstraintSet(
      top: equipmentLabel.topAnchor.constraint(equalTo: thumbnailsCollectionView.bottomAnchor, constant: CGFloat.packageSpacing),
      left: equipmentLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: equipmentLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0)
    ).activate()
    
    NSLayoutConstraintSet(
      top: priceIntervalLabel.topAnchor.constraint(equalTo: equipmentLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      centerX: priceIntervalLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0)
    ).activate()
    
    NSLayoutConstraintSet(
      top: priceAmountLabel.topAnchor.constraint(equalTo: priceIntervalLabel.bottomAnchor, constant: 5),
      centerX: priceAmountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0)
    ).activate()
    
    NSLayoutConstraintSet(
      top: viewPackageButton.topAnchor.constraint(equalTo: priceAmountLabel.bottomAnchor, constant: CGFloat.packageSpacing),
      bottom: viewPackageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CGFloat.packageSpacing),
      left: viewPackageButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
      right: viewPackageButton.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0),
      height: viewPackageButton.heightAnchor.constraint(equalToConstant: CGFloat.buttonHeight)
    ).activate()
    
    thumbnailsCollectionView.delegate = self
    thumbnailsCollectionView.dataSource = self
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let vm = viewModel else {
      return
    }
    
    let ip = IndexPath(item: vm.selectedIndex, section: 0)
    
    if let selectedCell = thumbnailsCollectionView.cellForItem(at: ip) as? PackageThumbnailCollectionViewCell,
       thumbnailsCollectionView.indexPathsForSelectedItems?.isEmpty ?? false {
      
      thumbnailsCollectionView.selectItem(at: ip, animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
      
      guard let imageUrl = selectedCell.viewModel?.imageUrl else {
        return
      }
      
      PhotoCache.instance.fetchPhoto(urlString: imageUrl) { (image) in
        DispatchQueue.main.async { [weak self] in
          self?.currentThumbnailImageView.image = image
        }
      }
    }
  }
}

extension PackageCardCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return viewModel?.thumbnailVms.count ?? 0
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let viewModel = viewModel?.thumbnailVms[indexPath.item],
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PackageThumbnailCollectionViewCell.self), for: indexPath) as? PackageThumbnailCollectionViewCell {
      cell.viewModel = viewModel
      
      return cell
    }
    
    return UICollectionViewCell(frame: CGRect.zero)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return CGFloat.thumbnailSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(
      width: PackageCardCollectionViewCell.ThumbnailCollectionHeight,
      height: PackageCardCollectionViewCell.ThumbnailCollectionHeight
    )
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let selectedVm = viewModel?.thumbnailVms[indexPath.item] {
      self.viewModel?.selectThumbnailIndex(indexPath.item)
      
      collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
      
      PhotoCache.instance.fetchPhoto(urlString: selectedVm.imageUrl) { (image) in
        DispatchQueue.main.async { [weak self] in
          self?.currentThumbnailImageView.image = image
        }
      }
    }
  }
}
