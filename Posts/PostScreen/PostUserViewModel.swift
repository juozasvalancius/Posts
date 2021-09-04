import UIKit
import Combine

final class PostUserViewModel {

  private let urlOpener: URLOpener
  private let user: User?

  var userID: Int? {
    return user?.id
  }

  let profilePicture: UIImage
  let name: String
  let company: String
  let email: String
  let phone: String
  let address: String

  private var openURLObservation: AnyCancellable?

  init(urlOpener: URLOpener) {
    self.urlOpener = urlOpener
    user = nil

    self.profilePicture = #imageLiteral(resourceName: "PlaceholderProfile")

    name = ""
    company = ""
    email = ""
    phone = ""
    address = ""
  }

  init(urlOpener: URLOpener, user: User, profilePicture: UIImage?) {
    self.urlOpener = urlOpener
    self.user = user

    self.profilePicture = profilePicture ?? #imageLiteral(resourceName: "PlaceholderProfile")

    name = user.name
    company = user.company.name
    email = user.email
    phone = user.phone
    address = user.address.formatted
  }

  func didClickEmail() {
    guard let url = detect(.link, in: email)?.url, url.scheme == "mailto" else {
      return
    }

    open(url)
  }

  func didClickPhone() {
    guard let phone = detect(.phoneNumber, in: phone)?.phoneNumber else {
      return
    }

    var components = URLComponents()
    components.scheme = "tel"
    components.path = phone

    guard let phoneURL = components.url else {
      return
    }

    open(phoneURL)
  }

  func didClickAddress() {
    guard
      let location = user?.address.geo,
      var components = URLComponents(string: "https://www.google.com/maps/search/")
    else {
      return
    }

    components.queryItems = [
      URLQueryItem(name: "api", value: "1"),
      URLQueryItem(name: "query", value: "\(location.latitude),\(location.longitude)"),
    ]

    guard let url = components.url else {
      return
    }

    open(url)
  }

  private func detect(
    _ type: NSTextCheckingResult.CheckingType,
    in text: String
  ) -> NSTextCheckingResult? {
    let range = NSRange(text.startIndex ..< text.endIndex, in: text)

    return try? NSDataDetector(types: type.rawValue)
      .firstMatch(in: text, options: [], range: range)
  }

  private func open(_ url: URL) {
    openURLObservation = urlOpener.open(url)
      .sink { success in
        if !success {
          print("Error opening URL")
        }
      }
  }

}

extension Address {
  var formatted: String {
    return "\(street), \(suite), \(city), \(zipcode)"
  }
}
