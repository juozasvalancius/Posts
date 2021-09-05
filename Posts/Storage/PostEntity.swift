import CoreData

extension PostEntity {

  var post: Post {
    return Post(
      id: Int(exactly: identifier) ?? 0,
      userID: Int(exactly: userID) ?? 0,
      title: title ?? "",
      body: body ?? ""
    )
  }

  func updateFields(with post: Post) {
    identifier = Int64(post.id)
    userID = Int64(post.userID)
    title = post.title
    body = post.body
  }

}
