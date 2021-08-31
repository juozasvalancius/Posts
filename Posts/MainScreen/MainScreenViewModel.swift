import Foundation
import Combine

final class MainScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let dataLoader: DataLoader

  @Published
  private(set) var postIDs = [Int]()

  @Published
  private(set) var isRefreshing = false

  private var reloadCancellable: AnyCancellable?

  @Published
  private(set) var presentedPostScreen: PostScreenViewModel?

  var presentedPostID: Int? {
    get {
      return presentedPostScreen?.postID
    } set {
      if let postID = newValue {
        presentedPostScreen = makePostScreenViewModel(id: postID)
      } else {
        presentedPostScreen = nil
      }
    }
  }

  init(storage: AppStorage, dataLoader: DataLoader) {
    self.storage = storage
    self.dataLoader = dataLoader

    // observe strage changes
    storage.sortedPostIDs().assign(to: &$postIDs)
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

  private func makePostScreenViewModel(id: Int) -> PostScreenViewModel {
    return PostScreenViewModel(storage: storage, dataLoader: dataLoader, postID: id)
  }

  func didRequestRefresh() {
    guard !isRefreshing else {
      return
    }

    isRefreshing = true

    reloadCancellable = dataLoader.updatePostList()
      .catch { error -> Just<Void> in
        print(error)
        return Just(())
      }
      .sink { [weak self] in
        self?.reloadCancellable = nil
        self?.isRefreshing = false
      }
  }

}

struct PostRowViewModel: Identifiable {
  let id: Int
  let title: String
  let body: String
  let user: String
}
