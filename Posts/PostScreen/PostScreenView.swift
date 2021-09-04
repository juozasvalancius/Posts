import SwiftUI

struct PostScreenView: View {

  @ObservedObject
  var viewModel: PostScreenViewModel

  @State
  var isRefreshing: Bool = false

  var body: some View {
    LegacyScrollView {
      VStack(spacing: 16) {
        PostUserView(viewModel: viewModel.user)
          .layoutPriority(1)
        PostContentView(dataModel: viewModel.post)
      }
      .padding()
    }
    .refreshable(isRefreshing: isRefreshing) {
      viewModel.didRequestRefresh()
    }
    .navigationBarTitle("Post", displayMode: .inline)
  }

}

struct PostScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    PostScreenView(
      viewModel: PostScreenViewModel(
        storage: MemoryStorage.makeWithMockData(),
        dataLoader: BlankDataLoader(),
        urlOpener: SystemURLOpener(),
        postID: 3
      )
    )
  }
}
