import Combine

/// An implementation of `AppStorage` that stores all data in RAM.
final class MemoryStorage: AppStorage {

  @Published
  private var posts = [Int: Post]()

  @Published
  private var users = [Int: User]()

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

  func usersChange() -> AnyPublisher<Void, Never> {
    return $users.map({ _ in }).eraseToAnyPublisher()
  }

  func getPost(id: Int) -> Post? {
    return posts[id]
  }

  func getUser(id: Int) -> User? {
    return users[id]
  }

  func nextMissingUser() -> Int? {
    return posts.values
      .first(where: { users[$0.userID] == nil })?
      .userID
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
