import SwiftUI

struct PostEntryView: View {

  let navigatedPostID: Binding<Int?>
  let viewModel: PostRowViewModel

  init(viewModel: PostRowViewModel, navigatedPostID: Binding<Int?>) {
    self.navigatedPostID = navigatedPostID
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationLink(
      destination: Text("Post #\(viewModel.id)"),
      tag: viewModel.id,
      selection: navigatedPostID
    ) {
      VStack(alignment: .leading) {
        Text(viewModel.user)
        Text(viewModel.title)
        Text(viewModel.body)
      }
      .lineLimit(1)
    }
  }
}

struct PostEntryViewPreviews: PreviewProvider {
  static var previews: some View {
    let viewModel = MainScreenViewModel(storage: MemoryStorage()).getRowViewModel(postID: 1)
    PostEntryView(viewModel: viewModel, navigatedPostID: .constant(nil))
  }
}
