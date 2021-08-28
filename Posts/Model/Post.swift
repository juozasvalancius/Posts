
struct Post: Decodable {

  let id: Int
  let userID: Int
  let title: String
  let body: String

  private enum CodingKeys: String, CodingKey {
    case id
    case userID = "userId"
    case title
    case body
  }

}
