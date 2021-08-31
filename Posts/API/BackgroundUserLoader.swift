import Foundation
import Combine

final class BackgroundUserLoader {

  private let storage: AppStorage
  private let dataLoader: DataLoader

  private var postListObservation: AnyCancellable?
  private var currentlyLoadingUserCancellable: AnyCancellable?

  init(storage: AppStorage, dataLoader: DataLoader) {
    self.storage = storage
    self.dataLoader = dataLoader

    postListObservation = storage.sortedPostIDs().sink { [weak self] _ in
      // values might get received before the update
      DispatchQueue.main.async { [weak self] in
        self?.loadNextUserDataIfNeeded()
      }
    }
  }

  /// - Parameters:
  ///   - needDelay: If there was an error previously,
  ///     set this to `true` to try again after a short delay.
  private func loadNextUserDataIfNeeded(needDelay: Bool = false) {
    guard currentlyLoadingUserCancellable == nil else {
      // only load a single user at a time in the background
      return
    }

    guard let userID = storage.nextMissingUser() else {
      return
    }

    currentlyLoadingUserCancellable = Just<Void>(())
      .delay(for: needDelay ? 1 : 0, scheduler: DispatchQueue.main)
      .flatMap { self.dataLoader.updateUser(id: userID) }
      .sink(receiveCompletion: self.didFinishLoading, receiveValue: { _ in })
  }

  private func didFinishLoading(_ result: Subscribers.Completion<APIError>) {
    currentlyLoadingUserCancellable = nil

    loadNextUserDataIfNeeded(needDelay: result != .finished)
  }

}
