//
//  VocabularyWord.swift
//  WordMate
//
//  Created by KangMingyo on 11/16/24.
//

import Foundation
import RealmSwift

class VocabularyWord: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var word: String
    @Persisted var pronunciation: String?
    @Persisted var meaning: String
    @Persisted var descriptionText: String?
    @Persisted var isLiked: Bool = false

    override init() {
        super.init()
    }

    convenience init(word: String, pronunciation: String? = nil, meaning: String, descriptionText: String? = nil, isLiked: Bool = false) {
        self.init()
        self.word = word
        self.pronunciation = pronunciation
        self.meaning = meaning
        self.descriptionText = descriptionText
        self.isLiked = isLiked
    }
}
