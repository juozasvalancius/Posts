import SwiftUI

/// A vertical scroll view that uses `UIScrollView`. Use together with `RefreshControl`.
struct LegacyScrollView<Content: View>: UIViewControllerRepresentable {

  @ViewBuilder
  var content: () -> Content

  func makeUIViewController(context: Context) -> HostingScrollViewController<Content> {
    return HostingScrollViewController(content: content())
  }

  func updateUIViewController(_ vc: HostingScrollViewController<Content>, context: Context) {
    vc.updateContent(content())
  }

}

final class HostingScrollViewController<Content: View>: UIViewController {

  let scrollView = UIScrollView()
  let contentVC: UIHostingController<Content>

  init(content: Content) {
    contentVC = UIHostingController(rootView: content)
    super.init(nibName: nil, bundle: nil)
    setupContentVC()
  }

  required init?(coder: NSCoder) {
    return nil
  }

  override func loadView() {
    view = scrollView
  }

  private func setupContentVC() {
    addChild(contentVC)

    if let contentView = contentVC.view {
      contentView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview(contentView)

      NSLayoutConstraint.activate([
        scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
        scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
    }

    contentVC.didMove(toParent: self)
  }

  func updateContent(_ newContent: Content) {
    contentVC.rootView = newContent
  }

}
