import Combine

protocol DataLoader {
  func updatePostList() -> AnyPublisher<Void, APIError>
  func updatePost(id: Int) -> AnyPublisher<Void, APIError>
  func updateUser(id: Int) -> AnyPublisher<Void, APIError>
}

/// Loads requested data from the API and passes it to the app storage.
final class StoringDataLoader: DataLoader {

  private let api: AppAPI
  private let storage: AppStorage

  init(api: AppAPI, storage: AppStorage) {
    self.api = api
    self.storage = storage
  }

  func updatePostList() -> AnyPublisher<Void, APIError> {
    return api.posts()
      .map { [weak storage] newPostList in
        storage?.updatePostList(newPostList)
      }
      .eraseToAnyPublisher()
  }

  func updatePost(id: Int) -> AnyPublisher<Void, APIError> {
    return api.post(id: id)
      .map { [weak storage] newPost in
        storage?.update(post: newPost)
      }
      .eraseToAnyPublisher()
  }

  func updateUser(id: Int) -> AnyPublisher<Void, APIError> {
    return api.user(id: id)
      .map { [weak storage] newUser in
        storage?.update(user: newUser)
      }
      .eraseToAnyPublisher()
  }

}
