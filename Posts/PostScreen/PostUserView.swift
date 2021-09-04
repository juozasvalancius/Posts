import SwiftUI

struct PostUserView: View {

  let viewModel: PostUserViewModel

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 20) {
        Circle()
          .frame(width: 88, height: 88)
        VStack(alignment: .leading) {
          Text(viewModel.name)
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true)
          Text(viewModel.company)
            .fixedSize(horizontal: false, vertical: true)
        }
        Spacer()
      }
      .padding()
      Separator()
      UserInfoCell(icon: "envelope", text: viewModel.email) {
        viewModel.didClickEmail()
      }
      Separator()
      UserInfoCell(icon: "phone", text: viewModel.phone) {
        viewModel.didClickPhone()
      }
      Separator()
      UserInfoCell(icon: "mappin.and.ellipse", text: viewModel.address) {
        viewModel.didClickAddress()
      }
    }
    .background(Color("BlockBackground"))
    .cornerRadius(8)
  }

}

struct UserInfoCell: View {

  let icon: String
  let text: String
  let action: () -> Void

  var body: some View {
    Button(action: action, label: {
      HStack(spacing: 0) {
        Image(systemName: icon)
          .frame(width: 44)
        Text(text)
          .padding(.vertical, 8)
        Spacer()
      }
      .frame(minHeight: 44)
      .foregroundColor(.blue)
      .contentShape(Rectangle().inset(by: 8)) // makes sure the Spacer is tappable
    })
    .buttonStyle(HighlightingButtonStyle())
  }
}

struct HighlightingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .overlay(
        Color("Background")
          .opacity(configuration.isPressed ? 0.5 : 0)
      )
  }
}

struct Separator: View {
  var body: some View {
    Rectangle()
      .foregroundColor(Color("Background"))
      .frame(height: 1)
  }
}

struct PostUserViewPreviews: PreviewProvider {
  static var previews: some View {
    let user = MemoryStorage.makeWithMockData().getUser(id: 1)
    PostUserView(
      viewModel: PostUserViewModel(urlOpener: SystemURLOpener(), user: user)!
    )
    .padding()
  }
}
