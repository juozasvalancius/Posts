
struct Services {

  let api: AppAPI
  let storage: AppStorage
  let dataLoader: DataLoader

  init() {
    api = TypicodeAPI()
    storage = MemoryStorage()
    dataLoader = StoringDataLoader(api: api, storage: storage)
  }

}
