import Foundation
import UIKit

struct PackageThumbnailViewModel {
  let imageUrl: String
}

class PackageThumbnailCollectionViewCell: UICollectionViewCell {
  
  var viewModel: PackageThumbnailViewModel? {
    didSet {
      guard let vm = viewModel else {
        return
      }
      
      PhotoCache.instance.fetchPhoto(urlString: vm.imageUrl) { [weak self] (image) in
        
        DispatchQueue.main.async {
          self?.thumbnailImageView.image = image
        }
      }
    }
  }
  
  private lazy var thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.borderWidth = 4
    imageView.layer.cornerRadius = CGFloat.thumbnailRadius
    imageView.clipsToBounds = true
    imageView.layer.borderColor = UIColor.thumbnailBorder(selected: false).cgColor
    self.contentView.addSubview(imageView)
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  override var isSelected: Bool {
    didSet {
      thumbnailImageView.layer.borderColor = UIColor.thumbnailBorder(selected: isSelected).cgColor
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  func commonInit() {
    NSLayoutConstraintSet(
      top:    thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      bottom: thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
      left:   thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
      right:  thumbnailImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
    ).activate()
    
    thumbnailImageView.backgroundColor = UIColor.primaryBackground
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    isSelected = false
    thumbnailImageView.image = nil
  }
}

class PhotoCache {
  static let instance = PhotoCache()
  private let queue = DispatchQueue(label: "com.fightcamp.photocache", qos: DispatchQoS.userInteractive)
 
  private init() {
    //
  }
  
  private var cache = [String: UIImage]()
  
  func fetchPhoto(urlString: String, checkCache: Bool = true, completion: @escaping (UIImage?)-> Void) {
    
    if checkCache {
      queue.sync {
        if let cachedPhotoData = cache[urlString] {
          completion(cachedPhotoData)
          return
        }
      }
    }
    
    DispatchQueue.global().async { [weak self] in
      if let url = URL(string: urlString),
         let data = try? Data(contentsOf: url),
         let image = UIImage(data: data) {
        
        self?.queue.async {
          self?.cache[urlString] = image
        }
        
        completion(image)
      }
    }
  }
}
