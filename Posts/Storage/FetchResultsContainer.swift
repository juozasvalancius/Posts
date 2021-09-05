import CoreData
import Combine

/// Observes changes in a CoreData fetch request.
final class FetchResultsContainer<Result: NSFetchRequestResult>:
  NSObject, NSFetchedResultsControllerDelegate {

  private let resultsController: NSFetchedResultsController<Result>
  private var values = CurrentValueSubject<[Result], Error>([])

  var publisher: AnyPublisher<[Result], Error> {
    // keep a strong reference to self, so the publishers can receive values
    return CurrentValueSubject<FetchResultsContainer<Result>, Error>(self)
      .flatMap(\.values)
      .eraseToAnyPublisher()
  }

  init(fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
    resultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    super.init()

    resultsController.delegate = self

    do {
      try resultsController.performFetch()
      update()
    } catch {
      resultsController.delegate = nil
      values.send(completion: .failure(error))
    }
  }

  deinit {
    resultsController.delegate = nil
  }

  func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
    update()
  }

  func update() {
    values.send(resultsController.fetchedObjects ?? [])
  }

}
