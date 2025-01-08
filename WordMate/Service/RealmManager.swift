//
//  RealmManager.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

protocol RealmManagerProtocol {
    func fetchObject<T: Object>(_ object: T.Type) -> Results<T>
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T?
    func addObject<T: Object>(_ object: T, action: ((T) -> Void)?)
    func deleteObject<T: Object>(_ object: T)
    func updateObject<T: Object>(_ object: T, updates: (T) -> Void)
}

final class RealmManager: RealmManagerProtocol {
    
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    // MARK: - Add
    func addObject<T: Object>(_ object: T, action: ((T) -> Void)?) {
        try? realm.write {
            action?(object)
            realm.add(object, update: .modified)
        }
    }
    
    // MARK: - Fetch
    func fetchObject<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T? {
        return realm.object(ofType: type, forPrimaryKey: id)
    }
    
    // MARK: - Update
    func updateObject<T: Object>(_ object: T, updates: (T) -> Void) {
        try? realm.write {
            updates(object)
        }
    }
    
    // MARK: - Delete
    func deleteObject<T: Object>(_ object: T) {
        try? realm.write {
            realm.delete(object)
        }
    }
}
