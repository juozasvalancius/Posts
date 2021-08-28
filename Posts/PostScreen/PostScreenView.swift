import SwiftUI

struct PostScreenView: View {

  @ObservedObject
  var viewModel: PostScreenViewModel

  @State
  var isRefreshing: Bool = false

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Text("User:")
          Text(viewModel.user.name)
          Spacer()
        }
        .padding()
        .background(Color(white: 0, opacity: 0.2))
        .cornerRadius(8)
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
    }.refreshable(isRefreshing: $isRefreshing) {
      // fake refresh
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        isRefreshing = false
      }
    }
    .navigationBarTitle(viewModel.post.title, displayMode: .inline)
  }

}

struct PostScreenViewPreviews: PreviewProvider {
  static var previews: some View {
    PostScreenView(
      viewModel: PostScreenViewModel(storage: MemoryStorage(), postID: 1)
    )
  }
}
