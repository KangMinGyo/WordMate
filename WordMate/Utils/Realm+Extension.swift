//
//  Realm+Extension.swift
//  WordMate
//
//  Created by KangMingyo on 1/3/25.
//

import Foundation
import RealmSwift

extension Realm {
    func isGroupExisting(name: String) -> Bool {
        let predicate = NSPredicate(format: "name == %@", name)
        return !objects(VocabularyGroup.self).filter(predicate).isEmpty
    }
    
    func isWordExisting(name: String, meaning: String) -> Bool {
        let predicate = NSPredicate(format: "name == %@ AND meaning == %@", name, meaning)
        return !objects(VocabularyWord.self).filter(predicate).isEmpty
    }
}
