import Combine

final class DataManager {

  private let api: AppAPI
  private let storage: AppStorage

  init(api: AppAPI, storage: AppStorage) {
    self.api = api
    self.storage = storage
  }

  func updatePostList() -> AnyPublisher<[Post], APIError> {
    return api.posts()
      .interceptOutput { [weak storage] newPostList in
        storage?.updatePostList(newPostList)
      }
  }

  func updatePost(id: Int) -> AnyPublisher<Post, APIError> {
    return api.post(id: id)
      .interceptOutput { [weak storage] newPost in
        storage?.update(post: newPost)
      }
  }

  func updateUser(id: Int) -> AnyPublisher<User, APIError> {
    return api.user(id: id)
      .interceptOutput { [weak storage] newUser in
        storage?.update(user: newUser)
      }
  }

}

extension Publisher {
  func interceptOutput(_ body: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
    return handleEvents(receiveOutput: body)
      .eraseToAnyPublisher()
  }
}
