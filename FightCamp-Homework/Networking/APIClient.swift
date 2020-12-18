import Foundation

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
