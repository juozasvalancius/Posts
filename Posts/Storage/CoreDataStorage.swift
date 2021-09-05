import CoreData
import Combine

final class CoreDataStorage: AppStorage {

  private let container = NSPersistentContainer(name: "CoreDataModel")

  init() {
    // by default, the persistent store is synchronous
    container.loadPersistentStores { _, _ in }
  }

  private var context: NSManagedObjectContext {
    return container.viewContext
  }

  private lazy var sortedPostEntities: FetchResultsContainer<PostEntity> = {
    let fetchRequest = NSFetchRequest<PostEntity>(entityName: "PostEntity")
    fetchRequest.propertiesToFetch = ["identifier"]
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
    return FetchResultsContainer(fetchRequest: fetchRequest, context: context)
  }()

  private lazy var userEntities: FetchResultsContainer<UserEntity> = {
    let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
    fetchRequest.propertiesToFetch = []
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
    return FetchResultsContainer(fetchRequest: fetchRequest, context: context)
  }()

  func sortedPostIDs() -> AnyPublisher<[Int], Never> {
    return sortedPostEntities.publisher
      .map { entityList -> [Int] in
        entityList.map { entity in
          Int(entity.identifier)
        }
      }
      .catch { error -> Just<[Int]> in
        return Just<[Int]>([])
      }
      .eraseToAnyPublisher()
  }

  func post(id: Int) -> AnyPublisher<Post?, Never> {
    let fetchRequest = NSFetchRequest<PostEntity>(entityName: "PostEntity")
    fetchRequest.predicate = NSPredicate(format: "identifier = %d", id)
    fetchRequest.fetchLimit = 1
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
    return FetchResultsContainer(fetchRequest: fetchRequest, context: context).publisher
      .map(\.first?.post)
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }

  func user(id: Int) -> AnyPublisher<User?, Never> {
    let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
    fetchRequest.predicate = NSPredicate(format: "identifier = %d", id)
    fetchRequest.fetchLimit = 1
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifier", ascending: true)]
    return FetchResultsContainer(fetchRequest: fetchRequest, context: context).publisher
      .map(\.first?.user)
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }

  func usersChange() -> AnyPublisher<Void, Never> {
    return userEntities.publisher
      .map { _ in () }
      .catch { error -> Just<Void> in
        return Just<Void>(())
      }
      .eraseToAnyPublisher()
  }

  func getPost(id: Int) -> Post? {
    getExistingPostEntity(id: id)?.post
  }

  func getUser(id: Int) -> User? {
    getExistingUserEntity(id: id)?.user
  }

  func nextMissingUser() -> Int? {
    let postsWithoutUsers = NSFetchRequest<PostEntity>(entityName: "PostEntity")
    postsWithoutUsers.predicate = NSPredicate(format: "userEntity == nil")
    postsWithoutUsers.fetchLimit = 1

    guard
      let results = try? context.fetch(postsWithoutUsers),
      let entity = results.first,
      let userID = Int(exactly: entity.userID)
    else {
      return nil
    }

    return userID
  }

  func updatePostList(_ posts: [Post]) {
    posts.forEach(updateWithoutSaving)
    try? context.save()
  }

  func update(post: Post) {
    updateWithoutSaving(post: post)
    try? context.save()
  }

  private func updateWithoutSaving(post: Post) {
    // get existing entity or create a new one
    let entity = getExistingPostEntity(id: post.id) ?? PostEntity(context: context)

    // update link to user
    entity.userEntity = getExistingUserEntity(id: post.userID)

    // update fields
    entity.updateFields(with: post)
  }

  func update(user: User) {
    if let existingEntity = getExistingUserEntity(id: user.id) {
      existingEntity.updateFields(with: user)
    } else {
      let newUserEntity = UserEntity(context: context)
      newUserEntity.updateFields(with: user)

      // setup links to this user
      let postsRequest = NSFetchRequest<PostEntity>(entityName: "PostEntity")
      postsRequest.predicate = NSPredicate(format: "userID = %d", user.id)
      postsRequest.propertiesToFetch = ["userEntity"]
      newUserEntity.postEntities = NSSet(array: (try? context.fetch(postsRequest)) ?? [])
    }

    try? context.save()
  }

  private func getExistingPostEntity(id: Int) -> PostEntity? {
    let existingRequest = NSFetchRequest<PostEntity>(entityName: "PostEntity")
    existingRequest.predicate = NSPredicate(format: "identifier = %d", id)
    existingRequest.fetchLimit = 1
    return try? context.fetch(existingRequest).first
  }

  private func getExistingUserEntity(id: Int) -> UserEntity? {
    let existingRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
    existingRequest.predicate = NSPredicate(format: "identifier = %d", id)
    existingRequest.fetchLimit = 1
    return try? context.fetch(existingRequest).first
  }

}
