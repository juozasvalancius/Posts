import Foundation
import Combine

final class PostScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let dataLoader: DataLoader

  let postID: Int

  @Published
  private(set) var post = PostDataModel()

  @Published
  private(set) var user = UserDataModel()

  @Published
  private(set) var isRefreshing = false

  private var storageObservation: Cancellable?
  private var reloadCancellable: AnyCancellable?

  init(storage: AppStorage, dataLoader: DataLoader, postID: Int) {
    self.storage = storage
    self.dataLoader = dataLoader
    self.postID = postID

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
      .compactMap(UserDataModel.init)
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

struct UserDataModel {

  let name: String
  let company: String
  let email: String
  let phone: String
  let address: String

  init() {
    name = ""
    company = ""
    email = ""
    phone = ""
    address = ""
  }

  init?(user: User?) {
    guard let user = user else {
      return nil
    }

    name = user.name
    company = user.company.name
    email = user.email
    phone = user.phone
    address = user.address.formatted
  }

}

extension Address {
  var formatted: String {
    return "\(street), \(suite), \(city), \(zipcode)"
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
