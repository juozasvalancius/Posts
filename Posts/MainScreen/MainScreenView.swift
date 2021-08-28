import SwiftUI

struct MainScreenView: View {

  @ObservedObject
  var viewModel: MainScreenViewModel

  @State
  var navigatedPostID: Int? = nil

  @State
  var isRefreshing: Bool = false

  var body: some View {
    List(viewModel.postIDs, id: \.self, selection: $navigatedPostID) { postID in
      NavigationLink(
        destination: Text("Post #\(postID)"),
        tag: postID,
        selection: $navigatedPostID
      ) {
        PostEntryView(viewModel: viewModel.makeRowViewModel(postID: postID))
      }
    }.refreshable(isRefreshing: $isRefreshing) {
      // fake refresh
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        isRefreshing = false
      }
    }
    .navigationBarTitle("Posts", displayMode: .inline)
  }

}

struct MainScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    MainScreenView(
      viewModel: MainScreenViewModel(storage: MemoryStorage())
    )
  }
}
