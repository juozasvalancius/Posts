import UIKit
import Combine

protocol URLOpener {
  func open(_: URL) -> AnyPublisher<Bool, Never>
}

struct SystemURLOpener: URLOpener {
  func open(_ url: URL) -> AnyPublisher<Bool, Never> {
    return Future { (completion: @escaping (Result<Bool, Never>) -> Void) in
      UIApplication.shared.open(url) { result in
        completion(.success(result))
      }
    }
    .eraseToAnyPublisher()
  }
}
