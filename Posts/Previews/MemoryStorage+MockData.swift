import Foundation

extension MemoryStorage {

  static func makeWithMockData() -> MemoryStorage {
    let storage = MemoryStorage()
    let posts = loadJSON([Post].self, from: "posts")
    let users = loadJSON([User].self, from: "users")
    storage.updatePostList(posts)
    users.forEach(storage.update(user:))
    return storage
  }

  private static func loadJSON<T: Decodable>(_ type: T.Type, from name: String) -> T {
    let url = Bundle.main.url(forResource: name, withExtension: "json")!
    return try! JSONDecoder().decode(T.self, from: Data(contentsOf: url))
  }

}
