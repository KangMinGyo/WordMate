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
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T?
    func addObject<T: Object>(_ object: T)
//    func deleteObject()
    func deleteObject<T: Object>(_ object: T)
    func addWordToGroup<T: VocabularyGroup, U: VocabularyWord>(_ group: T, word: U)
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
    
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T? {
        let realm = try! Realm()
        return realm.object(ofType: type, forPrimaryKey: id)
    }
    
    func addObject<T: Object>(_ object: T) {
        try? realm.write {
            realm.add(object)
        }
    }
    
    func addWordToGroup<T: VocabularyGroup, U: VocabularyWord>(_ group: T, word: U) {
        try? realm.write {
            group.words.append(word)
            realm.add(group, update: .modified)
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        print("삭제")
    }
    
    func deleteObject() {
        try? realm.write {
            realm.deleteAll()
        }
    }

}
