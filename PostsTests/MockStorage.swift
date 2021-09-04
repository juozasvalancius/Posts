@testable import Posts

struct MockStorage {
  static func make() -> AppStorage {
    let storage = MemoryStorage()
    storage.updatePostList([
      Post(id: 1, userID: 1, title: "One", body: "Lorem ipsum one"),
      Post(id: 2, userID: 1, title: "Two", body: "Lorem ipsum two"),
      Post(id: 3, userID: 2, title: "Three", body: "Lorem ipsum three"),
    ])
    storage.update(
      user: User(
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
    )
    return storage
  }
}
