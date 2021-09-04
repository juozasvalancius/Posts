import SwiftUI

@main
struct PostsApp: App {
  var body: some Scene {
    WindowGroup {
      AppRootView(services: AppServices())
    }
  }
}
