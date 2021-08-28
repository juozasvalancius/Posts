import SwiftUI

struct PostEntryView: View {

  let viewModel: PostRowViewModel

  init(viewModel: PostRowViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(viewModel.user)
      Text(viewModel.title)
      Text(viewModel.body)
    }
    .lineLimit(1)
  }

}

struct PostEntryViewPreviews: PreviewProvider {
  static var previews: some View {
    let services = Services()
    let viewModel = MainScreenViewModel(
      storage: services.storage,
      dataLoader: services.dataLoader
    ).makeRowViewModel(postID: 1)
    PostEntryView(viewModel: viewModel)
  }
}
