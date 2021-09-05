import SwiftUI

struct MainScreenView: View {

  @ObservedObject
  var viewModel: MainScreenViewModel

  var body: some View {
    List {
      ForEach(viewModel.postIDs, id: \.self) { postID in
        NavigationLink(
          destination: LazyView {
            if let viewModel = viewModel.presentedPostScreen {
              PostScreenView(viewModel: viewModel)
            }
          },
          tag: postID,
          selection: $viewModel.presentedPostID
        ) {
          PostEntryView(viewModel: viewModel.makeRowViewModel(postID: postID))
        }
      }
      .listRowBackground(Color("Background"))
    }
    .refreshable(isRefreshing: viewModel.isRefreshing) {
      viewModel.didRequestRefresh()
    }
    .errorAlert(message: $viewModel.error) {
      viewModel.didTapRetry()
    }
    .navigationBarTitle("Posts", displayMode: .inline)
  }

}

struct MainScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    MainScreenView(
      viewModel: MainScreenViewModel(
        storage: MemoryStorage.makeWithMockData(),
        dataLoader: BlankDataLoader(),
        urlOpener: SystemURLOpener(),
        imageLoader: BlankImageLoader()
      )
    )
  }
}
