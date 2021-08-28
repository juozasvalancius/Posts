import Foundation

struct User: Decodable {
  let id: Int
  let name: String
  let email: String
  let address: Address
  let phone: String
  let website: String
  let company: Company
}

struct Address: Decodable {
  let street: String
  let suite: String
  let city: String
  let zipcode: String
  let geo: Coordinate
}

struct Coordinate: Decodable {

  let latitude: Double
  let longitude: Double

  private enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lng"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.latitude = try container.decodeDoubleFromString(forKey: .latitude)
    self.longitude = try container.decodeDoubleFromString(forKey: .longitude)
  }

}

struct Company: Decodable {
  let name: String
  let catchPhrase: String
  let bs: String
}

extension KeyedDecodingContainer {
  func decodeDoubleFromString(forKey key: Key) throws -> Double {
    let string = try decode(String.self, forKey: key)
    guard let value = Double(string) else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "Could not convert \(string.debugDescription) to Double"
      )
    }
    return value
  }
}
