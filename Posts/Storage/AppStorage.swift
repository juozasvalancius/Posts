import Combine

protocol AppStorage: AnyObject {

  func sortedPostIDs() -> AnyPublisher<[Int], Never>
  func post(id: Int) -> AnyPublisher<Post?, Never>
  func user(id: Int) -> AnyPublisher<User?, Never>
  /// Emits an event everytime the a User is updated.
  func usersChange() -> AnyPublisher<Void, Never>

  func getPost(id: Int) -> Post?
  func getUser(id: Int) -> User?

  /// Scans all Posts and verifies that each has a User entry.
  /// Returns the first User ID that is not in the database.
  func nextMissingUser() -> Int?

  func updatePostList(_ posts: [Post])
  func update(post: Post)
  func update(user: User)

}
