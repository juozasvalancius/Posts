
struct PreviewServices: Services {

  var storage: AppStorage {
    return MemoryStorage.makeWithMockData()
  }

  var dataLoader: DataLoader {
    return BlankDataLoader()
  }

  var urlOpener: URLOpener {
    return SystemURLOpener()
  }

}
