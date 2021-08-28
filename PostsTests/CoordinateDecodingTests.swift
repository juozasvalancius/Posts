import XCTest
@testable import Posts

final class CoordinateDecodingTests: XCTestCase {

  func testValidDecoding() throws {
    let input = """
      {
        "lat": "-38.2386",
        "lng": "57.2232"
      }
      """.data(using: .utf8)!
    let result = try JSONDecoder().decode(Coordinate.self, from: input)
    XCTAssertEqual(result.latitude, -38.2386, accuracy: 0.0000001)
    XCTAssertEqual(result.longitude, 57.2232, accuracy: 0.0000001)
  }

  func testMalformedDecoding() {
    let input = """
      {
        "lat": "-38.2386",
        "lng": "not a number"
      }
      """.data(using: .utf8)!
    XCTAssertThrowsError(try JSONDecoder().decode(Coordinate.self, from: input))
  }

}
