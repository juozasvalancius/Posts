import UIKit
import Combine
@testable import Posts

final class MockImageLoader: ImageLoader {

  var imageToReturn: UIImage?

  func loadProfilePicture(forUser userID: Int, size: CGFloat) -> AnyPublisher<UIImage?, Never> {
    return Just(imageToReturn).eraseToAnyPublisher()
  }

}
