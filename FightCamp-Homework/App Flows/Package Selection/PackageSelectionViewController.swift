import Foundation
import UIKit

struct Package: Codable {
  let title: String
  let desc: String
  let thumbnail_urls: [String]?
  let included: [String]?
  let payment: String
  let price: Int
  let action: String
}

class PackageCellViewModel: CellItem {
  
  let title: NSAttributedString
  let description: NSAttributedString
  
  private let package: Package
  
  required init(package: Package) {
    self.package = package
    
    
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
    
    super.init(id: package.title)
  }
}

struct CheckoutPlanSelectionViewModel {
  
  private let client: APIClientType
  
  init(client: APIClientType) {
    self.client = client
  }
  
  func items(completion: @escaping ([PackageCellViewModel]?)-> Void) {
    client.getPackages { (x) in
      guard let packages = x else {
        completion(nil)
        return
      }
      
      completion(packages.map({PackageCellViewModel(package: $0)}))
    }
  }
}

class PackageSelectionViewController: UIViewController {
  private let viewModel: CheckoutPlanSelectionViewModel
  
  enum Section {
    case main
  }
  
  private let dataSource: UICollectionViewDiffableDataSource<Section, CellItem>
  private let collectionView: UICollectionView
  
  required init(viewModel: CheckoutPlanSelectionViewModel) {
    self.viewModel = viewModel
    
    
    let estimatedHeight = CGFloat(400)
    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                   subitem: item,
                                                   count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    section.interGroupSpacing = 20
    let layout = UICollectionViewCompositionalLayout(section: section)
    
//    let layout = UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .insetGrouped))
    
    self.collectionView = UICollectionView(
      frame: CGRect.zero,
      collectionViewLayout: layout
    )
    
    self.dataSource = UICollectionViewDiffableDataSource<Section, CellItem>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, viewModel: CellItem) -> UICollectionViewCell? in
      
      if let vm = viewModel as? PackageCellViewModel,
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PackageCardCollectionViewCell.self), for: indexPath) as? PackageCardCollectionViewCell {
        cell.viewModel = vm
        
        return cell
      }
      
      return UICollectionViewCell()
    }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.lightGray
    setUpCollectionView()
    configureHierarchy()
    
    viewModel.items { [weak self] (vms) in
      guard let cellItems = vms else {
        // show error here
        return
      }
      
      // initial data
      var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
      snapshot.appendSections([.main])
      snapshot.appendItems(cellItems)
      self?.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  private func setUpCollectionView() {
    collectionView.backgroundColor = .lightGray
    collectionView.register(PackageCardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PackageCardCollectionViewCell.self))
  }
  
  private func configureHierarchy() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraintSet(
      top:    collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      bottom: collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      left:   collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
      right:  collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
    ).activate()
    
    view.addSubview(collectionView)
  }
  
}


internal class NSLayoutConstraintSet {
  
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

protocol APIClientType {
  func getPackages(_ packages: @escaping (([Package]?)-> Void))
}

class LocalAPIClient: APIClientType {
  func getPackages(_ completion: @escaping (([Package]?)-> Void)) {
    guard let path = Bundle.main.path(forResource: "packages", ofType: "json"),
          let json = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8),
          let jsonData = json.data(using: .utf8),
          let packages = try? JSONDecoder().decode([Package].self, from: jsonData) else {
      completion(nil)
      return
    }
    
    completion(packages)
  }
}


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
