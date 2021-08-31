import XCTest
@testable import Posts

final class MainScreenViewModelTests: XCTestCase {

  var dataLoader: MockDataLoader!
  var viewModel: MainScreenViewModel!

  override func setUp() {
    dataLoader = MockDataLoader()
    viewModel = MainScreenViewModel(
      storage: MockStorage.make(),
      dataLoader: dataLoader
    )
  }

  func testPostIDs() {
    XCTAssertEqual(viewModel.postIDs, [1, 2, 3])
  }

  func testPostRowWithUser() {
    let row = viewModel.makeRowViewModel(postID: 1)
    XCTAssertEqual(row.id, 1)
    XCTAssertEqual(row.user, "John (Example Inc.)")
    XCTAssertEqual(row.title, "One")
    XCTAssertEqual(row.body, "Lorem ipsum one")
  }

  func testPostRowWithoutUser() {
    let row = viewModel.makeRowViewModel(postID: 3)
    XCTAssertEqual(row.id, 3)
    XCTAssertEqual(row.user, "...")
    XCTAssertEqual(row.title, "Three")
    XCTAssertEqual(row.body, "Lorem ipsum three")
  }

  func testRefreshState() {
    XCTAssertFalse(viewModel.isRefreshing)
    viewModel.didRequestRefresh()
    XCTAssertTrue(viewModel.isRefreshing)
    dataLoader.postListUpdate.send(())
    XCTAssertFalse(viewModel.isRefreshing)
  }

  func testInitiallyNotPresentedPostScreen() {
    XCTAssertNil(viewModel.presentedPostScreen)
    XCTAssertNil(viewModel.presentedPostID)
  }

  func testPostScreenPresentation() {
    viewModel.presentedPostID = 2
    XCTAssertEqual(viewModel.presentedPostID, 2)
    XCTAssertEqual(viewModel.presentedPostScreen?.postID, 2)
  }

}
