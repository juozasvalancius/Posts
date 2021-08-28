import SwiftUI

struct MainScreenView: View {

  @ObservedObject
  var viewModel: MainScreenViewModel

  @State
  var navigatedPostID: Int? = nil

  var body: some View {
    List(viewModel.postIDs, id: \.self, selection: $navigatedPostID) { postID in
      NavigationLink(
        destination: LazyView {
          PostScreenView(
            viewModel: PostScreenViewModel(storage: viewModel.storage, postID: postID)
          )
        },
        tag: postID,
        selection: $navigatedPostID
      ) {
        PostEntryView(viewModel: viewModel.makeRowViewModel(postID: postID))
      }
    }.refreshable(
      isRefreshing: Binding<Bool>(
        get: { viewModel.isRefreshing },
        set: { flag in
          if flag {
            viewModel.didRequestRefresh()
          }
        })
    ) {
      //
    }
    .navigationBarTitle("Posts", displayMode: .inline)
  }

}

struct MainScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    let services = Services()
    MainScreenView(
      viewModel: MainScreenViewModel(
        storage: services.storage,
        dataLoader: services.dataLoader
      )
    )
  }
}
