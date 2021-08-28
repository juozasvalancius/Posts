import Foundation

final class MainScreenViewModel: ObservableObject {

  private let storage: AppStorage

  @Published
  private(set) var postIDs: [Int]

  init(storage: AppStorage) {
    self.storage = storage

    postIDs = storage.getSortedPostIDs()
  }

  func makeRowViewModel(postID: Int) -> PostRowViewModel {
    guard let post = storage.getPost(id: postID) else {
      return PostRowViewModel(id: postID, title: "", body: "", user: "")
    }

    let userInfo: String

    if let user = storage.getUser(id: post.userID) {
      userInfo = "\(user.name) (\(user.company.name))"
    } else {
      userInfo = "..."
    }

    return PostRowViewModel(id: post.id, title: post.title, body: post.body, user: userInfo)
  }

}

struct PostRowViewModel: Identifiable {
  let id: Int
  let title: String
  let body: String
  let user: String
}
