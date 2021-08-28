import SwiftUI

struct AppRootView: View {

  let services = Services()

  var body: some View {
    NavigationView {
      MainScreenView(
        viewModel: MainScreenViewModel(
          storage: services.storage,
          dataLoader: services.dataLoader
        )
      )
    }
  }

}

struct AppRootViewPreviews: PreviewProvider {
  static var previews: some View {
    AppRootView()
  }
}
