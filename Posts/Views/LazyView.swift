import SwiftUI

struct LazyView<Content: View>: View {

  let builder: () -> Content

  init(@ViewBuilder builder: @escaping () -> Content) {
    self.builder = builder
  }

  var body: some View {
    builder()
  }

}
