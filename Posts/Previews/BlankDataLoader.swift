import Combine

/// Does not load any data. Used for Xcode Previews.
struct BlankDataLoader: DataLoader {

  func updatePostList() -> AnyPublisher<Void, APIError> {
    return Empty<Void, APIError>().eraseToAnyPublisher()
  }

  func updatePost(id: Int) -> AnyPublisher<Int, APIError> {
    return Empty<Int, APIError>().eraseToAnyPublisher()
  }

  func updateUser(id: Int) -> AnyPublisher<Void, APIError> {
    return Empty<Void, APIError>().eraseToAnyPublisher()
  }

}
