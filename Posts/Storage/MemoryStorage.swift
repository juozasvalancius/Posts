
/// An implementation of `AppStorage` that stores all data in RAM.
final class MemoryStorage: AppStorage {

  private var posts = [
    1: Post(id: 1, userID: 1, title: "One", body: "Lorem ipsum one"),
    2: Post(id: 2, userID: 1, title: "Two", body: "Lorem ipsum two"),
    3: Post(id: 3, userID: 2, title: "Three", body: "Lorem ipsum three"),
  ]

  private var users = [
    1: User(
      id: 1,
      name: "John",
      email: "john@example.com",
      address: Address(
        street: "str.",
        suite: "suite",
        city: "Vilnius",
        zipcode: "00123",
        geo: Coordinate(latitude: 0, longitude: 0)
      ),
      phone: "+1234567890",
      website: "example.com",
      company: Company(
        name: "Example Inc.",
        catchPhrase: "catch",
        bs: "bs"
      )
    )
  ]

  func getSortedPostIDs() -> [Int] {
    return posts.keys.sorted()
  }

  func getPost(id: Int) -> Post? {
    return posts[id]
  }

  func getUser(id: Int) -> User? {
    return users[id]
  }

}
