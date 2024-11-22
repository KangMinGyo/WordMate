//
//  RealmManager.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

protocol RealmManagerProtocol {
    func fetchObjects<T: Object>(_ object: T.Type) -> Results<T>
    func addObject<T: Object>(_ object: T)
    func deleteObject<T: Object>(_ object: T)
}

final class RealmManager: RealmManagerProtocol {
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func fetchObjects<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func addObject<T: Object>(_ object: T) {
        try? realm.write {
            realm.add(object)
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        print("삭제")
    }

}
