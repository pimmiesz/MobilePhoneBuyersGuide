// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let picture = try? newJSONDecoder().decode(Picture.self, from: jsonData)

import Foundation

// MARK: - PictureElement
struct PictureElement: Codable {
  let mobileID: Int
  let url: String
  let id: Int
  
  enum CodingKeys: String, CodingKey {
    case mobileID = "mobile_id"
    case url, id
  }
}

typealias Picture = [PictureElement]

