import Foundation
import UIKit

struct CheckoutPlanSelectionViewModel {
  
}

class CheckoutPlanSelectionViewController: UIViewController {
  private let viewModel: CheckoutPlanSelectionViewModel

  required init(viewModel: CheckoutPlanSelectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
  }
}
