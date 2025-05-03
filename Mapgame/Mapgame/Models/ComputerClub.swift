import Foundation

struct ComputerClub: Codable {
  let id: String
  let name: String
  let address: String
  let imageURL: String
  let hasLicense: Bool
  let desc: String? = nil
}
