import SwiftUI

struct MainScreenView: View {

  @ObservedObject
  var viewModel: MainScreenViewModel

  var body: some View {
    List(viewModel.postIDs, id: \.self) { postID in
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
    .refreshable(isRefreshing: viewModel.isRefreshing) {
      viewModel.didRequestRefresh()
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
        urlOpener: SystemURLOpener()
      )
    )
  }
}
