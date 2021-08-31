
struct Services {

  let api: AppAPI
  let storage: AppStorage
  let dataLoader: DataLoader
  let backgroundUserLoader: BackgroundUserLoader

  init() {
    api = TypicodeAPI()
    storage = MemoryStorage()
    dataLoader = StoringDataLoader(api: api, storage: storage)
    backgroundUserLoader = BackgroundUserLoader(storage: storage, dataLoader: dataLoader)
  }

}
