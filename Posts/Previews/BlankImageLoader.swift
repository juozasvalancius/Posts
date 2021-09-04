import UIKit
import Combine

/// Always loads `nil` values.
final class BlankImageLoader: ImageLoader {
  func loadProfilePicture(forUser userID: Int, size: CGFloat) -> AnyPublisher<UIImage?, Never> {
    return Just(nil).eraseToAnyPublisher()
  }
}
