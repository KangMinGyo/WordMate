//
//  WordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/22/24.
//

import Foundation

class WordViewModel {
    private let word: VocabularyWord
    private let realmManager: RealmManagerProtocol
    
    init(word: VocabularyWord, realmManager: RealmManagerProtocol) {
        self.word = word
        self.realmManager = realmManager
    }
    
    var name: String {
        return word.name
    }
    
    var pronunciation: String {
        return word.pronunciation ?? ""
    }
    
    var meaning: String {
        return word.meaning
    }
    
    var descriptionText: String {
        return word.descriptionText ?? ""
    }
    
    var isLiked: Bool {
        return word.isLiked
    }
    
    func updateIsLiked() {
        let newIsLiked = !isLiked
        realmManager.updateIsLiked(word, to: newIsLiked)
        print("newIsLiked : \(newIsLiked)")
    }
}
