import Foundation

protocol FileManagerProtocol {
    func getFile(fileName: String) -> Data?
    func fileExists(fileName: String) -> Bool
    func createFile(fileName: String, image: Data)
}

class MyFileManager: FileManagerProtocol {
    static let sharedInstance = MyFileManager()

    private init() {}

    func getFile(fileName: String) -> Data? {
        guard let filePath =  getFileURL(fileName: fileName)?.path else {return nil}
        return FileManager.default.contents(atPath: filePath)
    }

    func fileExists(fileName: String) -> Bool {
        guard let filePath =  getFileURL(fileName: fileName)?.path else {return false}
        return FileManager.default.fileExists(atPath: filePath)
    }

    func createFile(fileName: String, image: Data) {
        guard let filePath =  getFileURL(fileName: fileName)?.path() else {return}
        createDirectory(filePath: filePath)
        FileManager.default.createFile(atPath: filePath, contents: image)
    }

    private func getFileURL(fileName: String) -> URL? {
        return myDirectory()?.appendingPathComponent(fileName)
    }

    private func myDirectory() -> URL? {
        guard let myDirectoryPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        if !FileManager.default.fileExists(atPath: myDirectoryPath.path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: myDirectoryPath.path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print("Couldn't create directory")
            }
        }
        return myDirectoryPath
    }

    private func createDirectory(filePath: String) {
        var dirPath = filePath
        if let slashIndex = filePath.lastIndex(of: "/") {
            dirPath.removeSubrange(slashIndex..<dirPath.endIndex)
        }
        if !FileManager.default.fileExists(atPath: dirPath) {
            do {
                try FileManager.default.createDirectory(
                    atPath: dirPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print("Couldn't create weather directory")
            }
        }
    }
}
