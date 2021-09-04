
struct PreviewServices: Services {

  var storage: AppStorage {
    return MemoryStorage.makeWithMockData()
  }

  var dataLoader: DataLoader {
    return BlankDataLoader()
  }

}
