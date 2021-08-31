import Combine

protocol DataLoader {
  /// Returns a publisher that emits an event once reloading is completed.
  func updatePostList() -> AnyPublisher<Void, APIError>
  /// Returns a publisher that emits the **User ID** once the post is reloaded.
  func updatePost(id: Int) -> AnyPublisher<Int, APIError>
  /// Returns a publisher that emits an event once reloading is completed.
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

  func updatePost(id: Int) -> AnyPublisher<Int, APIError> {
    return api.post(id: id)
      .map { [weak storage] newPost in
        storage?.update(post: newPost)
        return newPost.userID
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
