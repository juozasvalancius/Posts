@testable import Posts

struct MockStorage {
  static func make() -> AppStorage {
    return MemoryStorage()
  }
}
