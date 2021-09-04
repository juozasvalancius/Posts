import SwiftUI

struct PostUserView: View {

  let dataModel: UserDataModel

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 20) {
        Circle()
          .frame(width: 88, height: 88)
        VStack(alignment: .leading) {
          Text(dataModel.name)
            .font(.headline)
          Text(dataModel.company)
        }
        Spacer()
      }
      .padding()
      Separator()
      UserInfoCell(icon: "envelope", text: dataModel.email)
      Separator()
      UserInfoCell(icon: "phone", text: dataModel.phone)
      Separator()
      UserInfoCell(icon: "mappin.and.ellipse", text: dataModel.address)
      Separator()
    }
    .background(Color(white: 0, opacity: 0.2))
    .cornerRadius(8)
  }

}

struct UserInfoCell: View {

  let icon: String
  let text: String

  var body: some View {
    Button(action: {}, label: {
      HStack(spacing: 0) {
        Image(systemName: icon)
          .frame(width: 44)
        Text(text)
          .padding(.vertical, 8)
        Spacer()
      }
      .frame(minHeight: 44)
      .foregroundColor(.blue)
    })
    .buttonStyle(HighlightingButtonStyle())
  }
}

struct HighlightingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .overlay(
        Color.white
          .opacity(configuration.isPressed ? 0.5 : 0)
      )
  }
}

struct Separator: View {
  var body: some View {
    Rectangle()
      .foregroundColor(.white)
      .frame(height: 1)
  }
}

struct PostUserViewPreviews: PreviewProvider {
  static var previews: some View {
    let user = MemoryStorage().getUser(id: 1)
    PostUserView(dataModel: UserDataModel(user: user)!)
      .frame(height: 120)
      .padding()
  }
}
