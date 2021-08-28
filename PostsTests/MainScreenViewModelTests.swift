import XCTest
@testable import Posts

final class MainScreenViewModelTests: XCTestCase {

  func testPostIDs() {
    let viewModel = MainScreenViewModel(storage: MockStorage.make())
    XCTAssertEqual(viewModel.postIDs, [1, 2, 3])
  }

  func testPostRowWithUser() {
    let viewModel = MainScreenViewModel(storage: MockStorage.make())
    let row = viewModel.makeRowViewModel(postID: 1)
    XCTAssertEqual(row.id, 1)
    XCTAssertEqual(row.user, "John (Example Inc.)")
    XCTAssertEqual(row.title, "One")
    XCTAssertEqual(row.body, "Lorem ipsum one")
  }

  func testPostRowWithoutUser() {
    let viewModel = MainScreenViewModel(storage: MockStorage.make())
    let row = viewModel.makeRowViewModel(postID: 3)
    XCTAssertEqual(row.id, 3)
    XCTAssertEqual(row.user, "...")
    XCTAssertEqual(row.title, "Three")
    XCTAssertEqual(row.body, "Lorem ipsum three")
  }

}
