//
//  VocabularyGroup.swift
//  WordMate
//
//  Created by KangMingyo on 11/16/24.
//

import Foundation
import RealmSwift

class VocabularyGroup: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var language: String
    @Persisted var words: List<VocabularyWord>

    override init() {
        super.init()
    }

    convenience init(name: String, language: String, words: [VocabularyWord] = []) {
        self.init()
        self.name = name
        self.language = language
        self.words.append(objectsIn: words)
    }
}
