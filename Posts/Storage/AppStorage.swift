
protocol AppStorage: AnyObject {

  func getSortedPostIDs() -> [Int]
  func getPost(id: Int) -> Post?
  func getUser(id: Int) -> User?

  func updatePostList(_ posts: [Post])
  func update(post: Post)
  func update(user: User)

}
