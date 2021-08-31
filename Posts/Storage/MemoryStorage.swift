import Combine

/// An implementation of `AppStorage` that stores all data in RAM.
final class MemoryStorage: AppStorage {

  @Published
  private var posts = [
    1: Post(id: 1, userID: 1, title: "One", body: "Lorem ipsum one"),
    2: Post(id: 2, userID: 1, title: "Two", body: "Lorem ipsum two"),
    3: Post(id: 3, userID: 2, title: "Three", body: "Lorem ipsum three"),
  ]

  @Published
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

  func sortedPostIDs() -> AnyPublisher<[Int], Never> {
    return $posts
      .map({ $0.keys.sorted() })
      .eraseToAnyPublisher()
  }

  func post(id: Int) -> AnyPublisher<Post?, Never> {
    return $posts.map(\.[id]).eraseToAnyPublisher()
  }

  func user(id: Int) -> AnyPublisher<User?, Never> {
    return $users.map(\.[id]).eraseToAnyPublisher()
  }

  func getPost(id: Int) -> Post? {
    return posts[id]
  }

  func getUser(id: Int) -> User? {
    return users[id]
  }

  func updatePostList(_ posts: [Post]) {
    self.posts = [Int: Post](
      posts.lazy.map({ ($0.id, $0) }),
      uniquingKeysWith: { lhs, _ in lhs }
    )
  }

  func update(post: Post) {
    posts[post.id] = post
  }

  func update(user: User) {
    users[user.id] = user
  }

}
