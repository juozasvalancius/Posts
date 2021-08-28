import SwiftUI

struct AppRootView: View {
  var body: some View {
    NavigationView {
      MainScreenView(
        viewModel: MainScreenViewModel(storage: MemoryStorage())
      )
    }
  }
}

struct AppRootViewPreviews: PreviewProvider {
  static var previews: some View {
    AppRootView()
  }
}
