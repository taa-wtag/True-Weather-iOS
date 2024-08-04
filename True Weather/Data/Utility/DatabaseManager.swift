import Foundation
import RealmSwift

protocol DatabaseManagerProtocol {
    func get<T: Object>(_ type: T.Type) -> T?
    func get<T: Object>(_ type: T.Type, predicate: (T) throws -> Bool) -> T?
    func getAll<T: Object>(_ type: T.Type) -> [T]?
    func save(_ object: Object?)
    func saveAll(_ array: [Object])
    func delete(_ object: Object?)
    func deleteAll(_ array: [Object])
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

    func delete(_ object: Object?) {
        if let realm = getRealm(), let object = object {
            try? realm.write {
                realm.delete(object, cascading: true)
            }
        }
    }

    func deleteAll(_ array: [Object]) {
        if let realm = getRealm() {
            try? realm.write {
                realm.delete(array, cascading: true)
            }
        }
    }

    func deleteAll<T: Object>(_ type: T.Type) {
        if let types = getAll(type){
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

extension Realm {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }

    func delete<T: Object>(_ entity: T, cascading: Bool) {
        for attr in Mirror(reflecting: entity).children {
            if let element = attr.value as? Object {
                delete(element, cascading: true)
            } else if let element = attr.value as? any Sequence {
                for obj in element {
                    if let item = obj as? Object {
                        delete(item, cascading: cascading)
                    }
                }
            }
        }
        delete(entity)
    }
}
