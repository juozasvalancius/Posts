import Foundation
import Combine

final class PostScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let dataLoader: DataLoader
  private let urlOpener: URLOpener

  let postID: Int

  @Published
  private(set) var post = PostDataModel()

  @Published
  private(set) var user: PostUserViewModel

  @Published
  private(set) var isRefreshing = false

  private var storageObservation: Cancellable?
  private var reloadCancellable: AnyCancellable?

  init(storage: AppStorage, dataLoader: DataLoader, urlOpener: URLOpener, postID: Int) {
    self.storage = storage
    self.dataLoader = dataLoader
    self.urlOpener = urlOpener
    self.postID = postID

    user = PostUserViewModel(urlOpener: urlOpener)

    // observe post changes
    let postPublisher = storage.post(id: postID)
      .share()
      .makeConnectable()

    // update post info UI
    postPublisher
      .compactMap(PostDataModel.init)
      .assign(to: &$post)

    // observe user changes and update UI
    postPublisher
      .compactMap(\.?.userID)
      .flatMap(storage.user(id:))
      .compactMap { [weak self] user in
        guard let self = self, let user = user else {
          return nil
        }
        return PostUserViewModel(urlOpener: self.urlOpener, user: user)
      }
      .assign(to: &$user)

    storageObservation = postPublisher.connect()
  }

  func didRequestRefresh() {
    guard !isRefreshing else {
      return
    }

    isRefreshing = true

    // load the post first, then update the user based on user id from the post
    reloadCancellable = dataLoader.updatePost(id: postID)
      .flatMap(dataLoader.updateUser(id:))
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

struct PostDataModel {

  let title: String
  let body: String

  init() {
    title = ""
    body = ""
  }

  init?(post: Post?) {
    guard let post = post else {
      return nil
    }

    title = post.title
    body = post.body
  }

}
