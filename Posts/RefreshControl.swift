import SwiftUI

extension View {
  func refreshable(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void) -> some View {
    let refreshControl = RefreshControl(
      isRefreshing: isRefreshing,
      onRefresh: onRefresh
    )
    return overlay(refreshControl.frame(width: 0, height: 0))
  }
}

/// Adds a shadow view that looks for a `UIScrollView` among its sibling subviews,
/// and adds a native `UIRefreshControl` to it.
private struct RefreshControl: UIViewRepresentable {

  @Binding
  var isRefreshing: Bool

  let onRefresh: () -> Void

  func makeUIView(context: Context) -> RefreshControlShadow {
    return RefreshControlShadow(view: self)
  }

  func updateUIView(_ view: RefreshControlShadow, context: Context) {
    view.isRefreshing = isRefreshing
  }

}

private final class RefreshControlShadow: UIView {

  var isRefreshing = false {
    didSet {
      updateUIRefreshControl()
    }
  }

  private weak var uiRefreshControl: UIRefreshControl?
  private let view: RefreshControl

  init(view: RefreshControl) {
    self.view = view
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    isUserInteractionEnabled = false
    isHidden = true
  }

  required init?(coder: NSCoder) {
    return nil
  }

  override func didMoveToWindow() {
    guard
      window != nil,
      uiRefreshControl == nil,
      let hostingView = superview?.superview,
      let scrollView = findScrollView(in: hostingView)
    else {
      return
    }

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(didInitiateRefresh), for: .valueChanged)
    scrollView.refreshControl = refreshControl
    self.uiRefreshControl = refreshControl
    updateUIRefreshControl()
  }

  /// Recursively finds a `UIScrollView`.
  private func findScrollView(in container: UIView) -> UIScrollView? {
    for subview in container.subviews {
      if let scrollView = subview as? UIScrollView ?? findScrollView(in: subview) {
        return scrollView
      }
    }
    return nil
  }

  @objc
  private func didInitiateRefresh() {
    view.isRefreshing = true
    view.onRefresh()
  }

  private func updateUIRefreshControl() {
    guard let refreshControl = self.uiRefreshControl else {
      return
    }

    guard refreshControl.isRefreshing != isRefreshing else {
      return
    }

    if isRefreshing {
      refreshControl.beginRefreshing()
    } else {
      refreshControl.endRefreshing()
    }
  }

}
