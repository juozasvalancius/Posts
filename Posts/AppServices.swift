
protocol Services {
  var storage: AppStorage { get }
  var dataLoader: DataLoader { get }
  var urlOpener: URLOpener { get }
  var imageLoader: ImageLoader { get }
}

struct AppServices: Services {

  let api: AppAPI
  let storage: AppStorage
  let dataLoader: DataLoader
  let backgroundUserLoader: BackgroundUserLoader
  let urlOpener: URLOpener
  let imageLoader: ImageLoader

  init() {
    api = TypicodeAPI()
    storage = CoreDataStorage()
    dataLoader = StoringDataLoader(api: api, storage: storage)
    backgroundUserLoader = BackgroundUserLoader(storage: storage, dataLoader: dataLoader)
    urlOpener = SystemURLOpener()
    imageLoader = UnsplashThumbnailLoader()
  }

}
