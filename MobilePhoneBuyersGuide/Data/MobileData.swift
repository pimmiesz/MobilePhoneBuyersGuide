// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mobileData = try? newJSONDecoder().decode(MobileData.self, from: jsonData)

import Foundation

// MARK: - MobileDatum

struct MobileElement: Codable {
  let thumbImageURL: String
  let brand: String
  let rating: Double
  let id: Int
  let name, mobileDatumDescription: String
  let price: Double
  
  enum CodingKeys: String, CodingKey {
    case thumbImageURL, brand, rating, id, name
    case mobileDatumDescription = "description"
    case price
  }
}

typealias MobileData = [MobileElement]
