import Foundation
import Combine
@testable import Posts

final class MockURLOpener: URLOpener {

  var shouldSucceed = true

  private(set) var openedURLs = [URL]()

  func open(_ url: URL) -> AnyPublisher<Bool, Never> {
    openedURLs.append(url)
    return Just(shouldSucceed).eraseToAnyPublisher()
  }

}
