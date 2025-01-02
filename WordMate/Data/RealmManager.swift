//
//  RealmManager.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

protocol RealmManagerProtocol {
    // Fetch
    func fetchObjects<T: Object>(_ object: T.Type) -> Results<T>
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T?
    
    // Add
    func addObject<T: Object>(_ object: T)
    func addWordToGroup<T: VocabularyGroup, U: VocabularyWord>(_ group: T, word: U)
    
    // Delete
    func deleteObject<T: Object>(_ object: T)
    
    // Update
    func updateIsLiked(for word: VocabularyWord, to isLiked: Bool)
    func updateGroupName(for group: VocabularyGroup, to newName: String)
    func updateWord(for word: VocabularyWord, name: String, meaning: String, pronunciation: String?, descriptionText: String?)
    
    // 중복 확인
    func isGroupExisting(name: String) -> Bool
    func isWordExisting(name: String, meaning: String) -> Bool
}

final class RealmManager: RealmManagerProtocol {
    
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    // MARK: - Fetch
    func fetchObjects<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func fetchObject<T: Object>(_ type: T.Type, for id: ObjectId) -> T? {
        let realm = try! Realm()
        return realm.object(ofType: type, forPrimaryKey: id)
    }
    
    // MARK: - Add
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
    
    // MARK: - Delete
    func deleteObject<T: Object>(_ object: T) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.delete(object)
        }
    }
    
    // MARK: - Update
    func updateIsLiked(for word: VocabularyWord, to isLiked: Bool) {
        try? realm.write {
            word.isLiked = isLiked
        }
    }
    
    func updateGroupName(for group: VocabularyGroup, to newName: String) {
        try? realm.write {
            group.name = newName
        }
    }
    
    func updateWord(for word: VocabularyWord, name: String, meaning: String, pronunciation: String?, descriptionText: String?) {
        try? realm.write {
            word.name = name
            word.meaning = meaning
            if let pronunciation = pronunciation {
                word.pronunciation = pronunciation
            }
            if let descriptionText = descriptionText {
                word.descriptionText = descriptionText
            }
        }
    }
    
    // MARK: - 중복 확인
    func isGroupExisting(name: String) -> Bool {
        let predicate = NSPredicate(format: "name == %@", name)
        let existingGroups = realm.objects(VocabularyGroup.self).filter(predicate)
        return !existingGroups.isEmpty
    }
    
    func isWordExisting(name: String, meaning: String) -> Bool {
        let predicate = NSPredicate(format: "name == %@ AND meaning == %@", name, meaning)
        let existingWords = realm.objects(VocabularyWord.self).filter(predicate)
        return !existingWords.isEmpty
    }
}
