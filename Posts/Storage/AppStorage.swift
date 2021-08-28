
protocol AppStorage {
  func getSortedPostIDs() -> [Int]
  func getPost(id: Int) -> Post?
  func getUser(id: Int) -> User?
}
