import SwiftUI
import Combine

extension View {
  func errorAlert(
    message: Binding<String?>,
    retryAction: @escaping () -> Void
  ) -> some View {
    return overlay(ErrorAlert(message: message, retryAction: retryAction))
  }
}

struct ErrorAlert: View {

  @Binding
  var message: String?

  let retryAction: () -> Void

  var body: some View {
    if let text = message {
      Color.primary
        .opacity(0.32)
        .overlay(
          VStack(spacing: 16) {
            Text(text)
            HStack {
              Button("OK") {
                message = nil
              }
              .frame(maxWidth: .infinity)
              Button("Retry") {
                message = nil
                retryAction()
              }
              .font(.system(.body).weight(.semibold))
              .frame(maxWidth: .infinity)
            }
          }
          .padding()
          .background(Color("Background").cornerRadius(8))
          .padding()
        )
        .transition(
          AnyTransition.opacity
            .combined(with: .scale(scale: 1.2))
            .animation(.easeIn(duration: 0.16))
        )
    }
  }

}

final class ErrorAlertPreviews: PreviewProvider {
  static var previews: some View {
    ErrorAlert(message: .constant("Some Error"), retryAction: {})
  }
}
