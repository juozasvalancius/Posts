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
    let viewModel = MainScreenViewModel(
      storage: MemoryStorage.makeWithMockData(),
      dataLoader: BlankDataLoader(),
      urlOpener: SystemURLOpener(),
      imageLoader: BlankImageLoader()
    ).makeRowViewModel(postID: 1)
    PostEntryView(viewModel: viewModel)
  }
}
