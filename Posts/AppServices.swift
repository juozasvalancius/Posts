
protocol Services {
  var storage: AppStorage { get }
  var dataLoader: DataLoader { get }
  var urlOpener: URLOpener { get }
}

struct AppServices: Services {

  let api: AppAPI
  let storage: AppStorage
  let dataLoader: DataLoader
  let backgroundUserLoader: BackgroundUserLoader
  let urlOpener: URLOpener

  init() {
    api = TypicodeAPI()
    storage = MemoryStorage()
    dataLoader = StoringDataLoader(api: api, storage: storage)
    backgroundUserLoader = BackgroundUserLoader(storage: storage, dataLoader: dataLoader)
    urlOpener = SystemURLOpener()
  }

}
