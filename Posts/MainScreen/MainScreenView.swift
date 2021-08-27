import SwiftUI

struct MainScreenView: View {

  @ObservedObject
  var viewModel: MainScreenViewModel

  @State
  var navigatedPostID: Int? = nil

  @State
  var isRefreshing: Bool = false

  var body: some View {
    List(viewModel.posts) { post in
        PostEntryView(post: post, navigatedPostID: $navigatedPostID)
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
    MainScreenView(viewModel: MainScreenViewModel())
  }
}
