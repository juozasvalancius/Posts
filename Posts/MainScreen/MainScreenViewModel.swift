import Foundation
import Combine

final class MainScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let dataLoader: DataLoader
  private let urlOpener: URLOpener
  private let imageLoader: ImageLoader

  @Published
  private(set) var postIDs = [Int]()

  @Published
  private(set) var isRefreshing = false

  private var reloadCancellable: AnyCancellable?
  private var usersObservation: AnyCancellable?

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

  init(
    storage: AppStorage,
    dataLoader: DataLoader,
    urlOpener: URLOpener,
    imageLoader: ImageLoader
  ) {
    self.storage = storage
    self.dataLoader = dataLoader
    self.urlOpener = urlOpener
    self.imageLoader = imageLoader

    // observe strage changes
    storage.sortedPostIDs().assign(to: &$postIDs)

    // force reload when users change in the database
    usersObservation = storage.usersChange().sink { [weak self] _ in
      self?.objectWillChange.send()
    }

    // refresh on open
    didRequestRefresh()
  }

  func makeRowViewModel(postID: Int) -> PostRowViewModel {
    guard let post = storage.getPost(id: postID) else {
      return PostRowViewModel(postID: postID)
    }

    return PostRowViewModel(post: post, user: storage.getUser(id: post.userID))
  }

  private func makePostScreenViewModel(id: Int) -> PostScreenViewModel {
    return PostScreenViewModel(
      storage: storage,
      dataLoader: dataLoader,
      urlOpener: urlOpener,
      imageLoader: imageLoader,
      postID: id
    )
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
  let userName: String
  let company: String

  init(postID: Int) {
    id = postID
    title = ""
    body = ""
    userName = ""
    company = ""
  }

  init(post: Post, user: User?) {
    id = post.id
    title = post.title
    body = post.body
    userName = user?.name ?? ""
    company = user?.company.name ?? "..."
  }

}
