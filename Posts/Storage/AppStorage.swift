import Combine

protocol AppStorage: AnyObject {

  func sortedPostIDs() -> AnyPublisher<[Int], Never>
  func post(id: Int) -> AnyPublisher<Post?, Never>
  func user(id: Int) -> AnyPublisher<User?, Never>

  func getPost(id: Int) -> Post?
  func getUser(id: Int) -> User?

  func updatePostList(_ posts: [Post])
  func update(post: Post)
  func update(user: User)

}
