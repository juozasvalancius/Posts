import UIKit
import Combine

protocol ImageLoader {
  /// Publishes image thumbnails that are generated for displaying on the main `UIScreen`
  /// in a `size`x`size` points square.
  func loadProfilePicture(forUser userID: Int, size: CGFloat) -> AnyPublisher<UIImage?, Never>
}

final class UnsplashThumbnailLoader: ImageLoader {

  private static let base = "https://source.unsplash.com/collection/542909/?sig="

  private let session: URLSession

  init() {
    let cacheDirectory = { () throws -> URL? in
      guard let bundleID = Bundle.main.bundleIdentifier else {
        return nil
      }
      let fileManager = FileManager.default
      var directory = try fileManager.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      directory.appendPathComponent(bundleID, isDirectory: true)
      directory.appendPathComponent("image-cache", isDirectory: true)
      try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
      return directory
    }

    let config = URLSessionConfiguration.default
    config.httpCookieStorage = nil
    config.urlCredentialStorage = nil
    config.urlCache = URLCache(
      memoryCapacity: 512 * 1024,    // 512 KB
      diskCapacity: 8 * 1024 * 1024, // 8 MB
      directory: try? cacheDirectory()
    )

    session = URLSession(configuration: config)
  }

  func loadProfilePicture(forUser userID: Int, size: CGFloat) -> AnyPublisher<UIImage?, Never> {
    guard let url = URL(string: UnsplashThumbnailLoader.base + String(userID)) else {
      return Just(nil).eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: url)
      .map { data, response in
        guard
          let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200
        else {
          return nil
        }

        return generateThumbnail(from: data, size: size)
      }
      .catch { _ in
        return Just(nil)
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

}

private func generateThumbnail(from data: Data, size: CGFloat) -> UIImage? {
  guard let imageSource = CGImageSourceCreateWithData(
    data as CFData,
    [kCGImageSourceShouldCache: false] as CFDictionary // don't decode entire image
  ) else {
    return nil
  }

  // get original image size in pixels
  guard
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil),
    let properties = cfProperties as? [CFString: Any],
    let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
    let height = properties[kCGImagePropertyPixelHeight] as? CGFloat
  else {
    return nil
  }

  let maxSize: CGFloat
  let screenScale = UIScreen.main.scale

  // calculate appropriate thumbnail size
  if width < height {
    maxSize = screenScale * (size * height) / width
  } else {
    maxSize = screenScale * (size * width) / height
  }

  // generate the thumbnail
  guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, [
    kCGImageSourceCreateThumbnailFromImageAlways: true,
    kCGImageSourceCreateThumbnailWithTransform: true,
    kCGImageSourceThumbnailMaxPixelSize: maxSize.rounded(),
  ] as CFDictionary) else {
    return nil
  }

  return UIImage(cgImage: thumbnail)
}
