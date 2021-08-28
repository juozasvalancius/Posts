import Foundation
import Combine

protocol AppAPI {
  func posts() -> AnyPublisher<[Post], APIError>
  func post(id: Int) -> AnyPublisher<Post, APIError>
  func user(id: Int) -> AnyPublisher<User, APIError>
}

enum APIError: Error {
  case internalInconsistency
  case badResponse
  case networkError
}

final class TypicodeAPI: AppAPI {

  private static let base = URL(string: "https://jsonplaceholder.typicode.com")

  private let session: URLSession

  init() {
    let config = URLSessionConfiguration.ephemeral
    config.httpCookieStorage = nil
    config.urlCache = nil
    config.urlCredentialStorage = nil
    session = URLSession(configuration: config)
  }

  func posts() -> AnyPublisher<[Post], APIError> {
    return loadJSON(path: "/posts")
  }

  func post(id: Int) -> AnyPublisher<Post, APIError> {
    return loadJSON(path: "/posts/\(id)")
  }

  func user(id: Int) -> AnyPublisher<User, APIError> {
    return loadJSON(path: "/users/\(id)")
  }

  private func loadJSON<Result: Decodable>(path: String) -> AnyPublisher<Result, APIError> {
    guard let url = URL(string: path, relativeTo: TypicodeAPI.base) else {
      return Fail(error: APIError.internalInconsistency).eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: url)
      .tryMap { data, response in
        print("API RESPONE", data.count)
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.internalInconsistency
        }
        guard httpResponse.statusCode == 200 else {
          throw APIError.badResponse
        }
        return data
      }
      .decode(type: Result.self, decoder: JSONDecoder())
      .mapError { error -> APIError in
        print("API ERROR", error)
        switch error {
        case is URLError:
          return APIError.networkError
        case is DecodingError:
          return APIError.badResponse
        case let error as APIError:
          return error
        default:
          return APIError.internalInconsistency
        }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

}
