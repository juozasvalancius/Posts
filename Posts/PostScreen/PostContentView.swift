import SwiftUI

struct PostContentView: View {

  let dataModel: PostDataModel

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text(dataModel.title)
          .font(.headline)
        Text(dataModel.body)
      }
      Spacer()
    }
    .padding()
    .background(Color("BlockBackground"))
    .cornerRadius(8)
  }

}

struct PostContentViewPreviews: PreviewProvider {
  static var previews: some View {
    let post = MemoryStorage.makeWithMockData().getPost(id: 1)
    PostContentView(dataModel: PostDataModel(post: post)!)
      .padding()
  }
}
