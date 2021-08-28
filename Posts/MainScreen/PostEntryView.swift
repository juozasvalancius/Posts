import SwiftUI

struct PostEntryView: View {

  let navigatedPostID: Binding<Int?>
  let post: PostRowViewModel

  init(post: PostRowViewModel, navigatedPostID: Binding<Int?>) {
    self.navigatedPostID = navigatedPostID
    self.post = post
  }

  var body: some View {
    NavigationLink(
      destination: Text("Post #\(post.id)"),
      tag: post.id,
      selection: navigatedPostID
    ) {
      VStack(alignment: .leading) {
        Text(post.userName ?? "-")
        Text(post.userCompany ?? "-")
        Text(post.title)
        Text(post.body)
      }
      .lineLimit(1)
    }
  }
}

struct PostEntryViewPreviews: PreviewProvider {
  static var previews: some View {
    let post = MainScreenViewModel().posts[0]
    PostEntryView(post: post, navigatedPostID: .constant(nil))
  }
}
