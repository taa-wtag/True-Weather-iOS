import Foundation
import RealmSwift
import Realm

protocol DatabaseManagerProtocol {
    func get<T: Object>(_ type: T.Type) -> T?
    func get<T: Object>(_ type: T.Type, predicate: (T) throws -> Bool) -> T?
    func getAll<T: Object>(_ type: T.Type) -> [T]?
    func save(_ object: Object?)
    func saveAll(_ array: [Object])
    func delete<T: Object>(_ type: T.Type?, where predicate: (Query<T>) -> Query<Bool>)
    func delete(_ object: ObjectBase?)
    func deleteAll(_ array: [Object])
    func delete<T>(_ array: T) where T: Sequence, T.Element: RLMObjectBase
    func deleteAll<T: Object>(_ type: T.Type)
    func clearDB()
}

class DatabaseManager: DatabaseManagerProtocol {
    let DBSCHEMAVERSION = UInt64(1)
    static let sharedInstance = DatabaseManager()

    private init() {}

    func getRealm() -> Realm? {
        return realmFor(realmFileName: "default.realm")
    }

    private func realmFor(realmFileName: String) -> Realm? {
        var config: Realm.Configuration
        config = Realm.Configuration(schemaVersion: DBSCHEMAVERSION)

        let realm = try? Realm(configuration: config)
        return realm
    }

    func get<T: Object>(_ type: T.Type) -> T? {
        return getRealm()?.objects(type).first
    }

    func get<T: Object>(_ type: T.Type, predicate: (T) throws -> Bool) -> T? {
        do {
            return try getRealm()?.objects(type).first(where: predicate)
        } catch {
            return nil
        }
    }

    func getAll<T: Object>(_ type: T.Type) -> [T]? {
        if let realm = getRealm() {
            return Array(realm.objects(type))
        }
        return nil
    }

    func update(_ object: Object?) {
        if let realm = getRealm(), let object = object {
            try? realm.write {
                realm.add(object, update: .modified)
            }
        }
    }

    func save(_ object: Object?) {
        if let realm = getRealm(), let object = object {
            try? realm.write {
              realm.add(object)
            }
        }
    }

    func saveAll(_ array: [Object]) {
        if let realm = getRealm(), !array.isEmpty {
            try? realm.write {
                realm.add(array)
            }
        }
    }

    func delete(_ object: ObjectBase?) {
        if let realm = getRealm(), let object = object {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func delete<T: Object>(_ type: T.Type?, where predicate: (Query<T>) -> Query<Bool>) {
        if let realm = getRealm(), let type = type {
            try? realm.write {
                realm.delete(realm.objects(type).where(predicate))
            }
        }
    }

    func delete<T: Object>(_ object: List<T>?) {
        if let realm = getRealm(), let object = object {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func deleteAll(_ array: [Object]) {
        if let realm = getRealm() {
            try? realm.write {
                realm.delete(array)
            }
        }
    }

    func delete<T>(_ array: T) where T: Sequence, T.Element: RLMObjectBase {
        if let realm = getRealm() {
            try? realm.write {
                realm.delete(array)
            }
        }
    }

    func deleteAll<T: Object>(_ type: T.Type) {
        if let types = getAll(type) {
            deleteAll(types)
        }
    }

    func clearDB() {
        if let realm = getRealm() {
            try? realm.write {
                realm.deleteAll()
            }
        }
    }
}
