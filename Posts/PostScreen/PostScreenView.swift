import SwiftUI

struct PostScreenView: View {

  @ObservedObject
  var viewModel: PostScreenViewModel

  @State
  var isRefreshing: Bool = false

  var body: some View {
    LegacyScrollView {
      VStack {
        PostUserView(dataModel: viewModel.user)
        HStack {
          VStack(alignment: .leading) {
            Text(viewModel.post.title)
            Text(viewModel.post.body)
          }
          Spacer()
        }
        .padding()
        .background(Color(white: 0, opacity: 0.2))
        .cornerRadius(8)
      }
      .padding()
    }
    .refreshable(isRefreshing: isRefreshing) {
      viewModel.didRequestRefresh()
    }
    .navigationBarTitle(viewModel.post.title, displayMode: .inline)
  }

}

struct PostScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    let services = Services()
    PostScreenView(
      viewModel: PostScreenViewModel(
        storage: services.storage,
        dataLoader: services.dataLoader,
        postID: 1
      )
    )
  }
}
