import SwiftUI

struct PostEntryView: View {

  let viewModel: PostRowViewModel

  init(viewModel: PostRowViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .firstTextBaseline) {
        Text(viewModel.userName)
          .font(.title3)
          .layoutPriority(1)
        Text(viewModel.company)
          .font(.caption)
        Spacer()
      }
      .foregroundColor(.accentColor)
      Text(viewModel.title)
        .font(.title)
      Text(viewModel.body)
        .font(.subheadline)
    }
    .padding(.vertical, 14)
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
