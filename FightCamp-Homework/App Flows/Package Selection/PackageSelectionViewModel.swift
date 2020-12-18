import Foundation

struct PackageSelectionViewModel {
  
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
