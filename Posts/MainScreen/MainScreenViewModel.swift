import Foundation

final class MainScreenViewModel: ObservableObject {
  @Published
  private(set) var posts: [Post] = [
    Post(id: 1, title: "One", body: "Lorem ipsum one", userName: nil, userCompany: nil),
    Post(id: 2, title: "Two", body: "Lorem ipsum two", userName: nil, userCompany: nil),
    Post(id: 3, title: "Three", body: "Lorem ipsum three", userName: nil, userCompany: nil),
  ]
}

struct Post: Identifiable {
  let id: Int
  let title: String
  let body: String
  let userName: String?
  let userCompany: String?
}
