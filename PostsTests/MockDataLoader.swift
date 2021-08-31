import Combine
@testable import Posts

final class MockDataLoader {
  let postListUpdate = PassthroughSubject<Void, APIError>()
  let postUpdate = PassthroughSubject<Int, APIError>()
  let userUpdate = PassthroughSubject<Void, APIError>()
}

extension MockDataLoader: DataLoader {

  func updatePostList() -> AnyPublisher<Void, APIError> {
    return postListUpdate.eraseToAnyPublisher()
  }

  func updatePost(id: Int) -> AnyPublisher<Int, APIError> {
    return postUpdate.eraseToAnyPublisher()
  }

  func updateUser(id: Int) -> AnyPublisher<Void, APIError> {
    return userUpdate.eraseToAnyPublisher()
  }

}
