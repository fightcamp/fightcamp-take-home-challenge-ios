import Foundation
import UIKit

class PackageSelectionViewController: UIViewController {
  private let viewModel: PackageSelectionViewModel
  
  enum Section {
    case main
  }
  
  private let dataSource: UICollectionViewDiffableDataSource<Section, CellItem>
  private let collectionView: UICollectionView
  
  required init(viewModel: PackageSelectionViewModel) {
    self.viewModel = viewModel
    
    
    let estimatedHeight = CGFloat(600)
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
    collectionView.backgroundColor = UIColor.secondaryBackground
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
