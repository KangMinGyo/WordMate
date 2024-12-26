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
    func deleteObject<T: Object>(_ object: T)
    func addWordToGroup<T: VocabularyGroup, U: VocabularyWord>(_ group: T, word: U)
    func updateIsLiked(_ word: VocabularyWord, to isLiked: Bool)
    func updateGroupName(_ group: VocabularyGroup, to newName: String)
    func updateWord(_ word: VocabularyWord, name: String, meaning: String, pronunciation: String?, descriptionText: String?)
}

final class RealmManager: RealmManagerProtocol {
    
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    // 그룹 불러오기
    func fetchObjects<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    // 단어 불러오기
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
    
    func updateIsLiked(_ word: VocabularyWord, to isLiked: Bool) {
        try! realm.write {
            word.isLiked = isLiked
        }
    }
    
    func updateGroupName(_ group: VocabularyGroup, to newName: String) {
        do {
            try realm.write {
                group.name = newName
            }
            print("그룹 이름 수정 완료")
        } catch {
            print("그룹 이름 수정 중 에러 발생: \(error.localizedDescription)")
        }
    }
    
    func updateWord(_ word: VocabularyWord, name: String, meaning: String, pronunciation: String?, descriptionText: String?) {
        do {
            try realm.write {
                word.name = name
                word.meaning = meaning
                if let pronunciation = pronunciation {
                    word.pronunciation = pronunciation
                }
                if let descriptionText = descriptionText {
                    word.descriptionText = descriptionText
                }
            }
            print("단어 업데이트 완료")
        } catch {
            print("단어 업데이트 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
            print("삭제 완료")
        } catch let error {
            print("삭제 중 에러 발생: \(error.localizedDescription)")
        }
    }
}
