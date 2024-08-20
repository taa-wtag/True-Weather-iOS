import Foundation

protocol WeatherIconServiceProtocol {
    func getIconFromRemote(url: String, completion: @escaping(Data) -> Void)
    func getIconFromCache(url: String, completion: @escaping(Data?) -> Void)
    func saveIcon(url: String, image: Data)
}

class WeatherIconService: WeatherIconServiceProtocol {
    static let shared = WeatherIconService()
    private let networkRequestService = NetworkRequestService.sharedInstance
    private let fileManager = MyFileManager.sharedInstance

    private init() {}

    func getIconFromRemote(url: String, completion: @escaping(Data) -> Void) {
        networkRequestService.request(url) { _, data in
            if let image = data?.pngData() {
                completion(image)
            }
        }
    }

    func getIconFromCache(url: String, completion: @escaping(Data?) -> Void) {
        if fileManager.fileExists(fileName: url) {
            completion(fileManager.getFile(fileName: url))
        } else {
            completion(nil)
        }
    }

    func saveIcon(url: String, image: Data) {
        fileManager.createFile(fileName: url, image: image)
    }
}
