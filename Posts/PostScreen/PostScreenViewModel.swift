import UIKit
import Combine

final class PostScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let dataLoader: DataLoader
  private let urlOpener: URLOpener
  private let imageLoader: ImageLoader

  let postID: Int

  @Published
  private(set) var post = PostDataModel()

  @Published
  private(set) var user: PostUserViewModel

  @Published
  private(set) var isRefreshing = false

  @Published
  private var userPicture: UIImage?

  @Published
  var error: String?

  private var storageObservation: Cancellable?
  private var reloadCancellable: AnyCancellable?
  private var userPictureCancellable: AnyCancellable?

  init(
    storage: AppStorage,
    dataLoader: DataLoader,
    urlOpener: URLOpener,
    imageLoader: ImageLoader,
    postID: Int
  ) {
    self.storage = storage
    self.dataLoader = dataLoader
    self.urlOpener = urlOpener
    self.imageLoader = imageLoader
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
      .compactMap({ $0 }) // continue only on successful user updates
      .combineLatest($userPicture) // combine user data and user photo updates
      .compactMap { [weak self] (user, photo) in
        guard let self = self else {
          return nil
        }
        if user.id != self.user.userID {
          self.refreshProfilePhoto(userID: user.id)
        }
        return PostUserViewModel(urlOpener: self.urlOpener, user: user, profilePicture: photo)
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
      .sink(receiveCompletion: { [weak self] completion in
        guard let self = self else {
          return
        }
        if case .failure(let error) = completion {
          self.error = error.userDescription
        } else {
          self.error = nil
        }
        self.reloadCancellable = nil
        self.isRefreshing = false
      }, receiveValue: { _ in })

    if let userID = user.userID {
      refreshProfilePhoto(userID: userID)
    }
  }

  private func refreshProfilePhoto(userID: Int) {
    // cancel any previous load and start new
    userPictureCancellable = imageLoader.loadProfilePicture(forUser: userID, size: 88)
      .sink { [weak self] image in
        self?.userPicture = image
      }
  }

  func didTapRetry() {
    didRequestRefresh()
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
