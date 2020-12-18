import Foundation

struct Package: Codable {
  let title: String
  let desc: String
  let thumbnail_urls: [String]?
  let included: [String]?
  let excluded: [String]?
  let payment: String
  let price: Int
  let action: String
}
