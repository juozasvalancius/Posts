import Foundation

final class MainScreenViewModel: ObservableObject {
  @Published
  private(set) var posts: [PostRowViewModel] = [
    PostRowViewModel(id: 1, title: "One", body: "Lorem ipsum one", userName: nil, userCompany: nil),
    PostRowViewModel(id: 2, title: "Two", body: "Lorem ipsum two", userName: nil, userCompany: nil),
    PostRowViewModel(id: 3, title: "Three", body: "Lorem ipsum three", userName: nil, userCompany: nil),
  ]
}

struct PostRowViewModel: Identifiable {
  let id: Int
  let title: String
  let body: String
  let userName: String?
  let userCompany: String?
}
