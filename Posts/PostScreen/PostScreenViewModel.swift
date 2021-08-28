import Foundation

final class PostScreenViewModel: ObservableObject {

  private let storage: AppStorage
  private let postID: Int

  @Published
  var post: PostDataModel

  @Published
  var user: UserDataModel

  init(storage: AppStorage, postID: Int) {
    self.storage = storage
    self.postID = postID

    guard let post = storage.getPost(id: postID) else {
      self.user = UserDataModel(name: "")
      self.post = PostDataModel(title: "", body: "")
      return
    }

    self.post = PostDataModel(title: post.title, body: post.body)

    if let user = storage.getUser(id: post.userID) {
      self.user = UserDataModel(name: user.name)
    } else {
      self.user = UserDataModel(name: "")
    }
  }

}

struct UserDataModel {
  let name: String
}

struct PostDataModel {
  let title: String
  let body: String
}
