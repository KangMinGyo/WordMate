//
//  WordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/22/24.
//

import Foundation

class WordViewModel {
    private let word: VocabularyWord
    
    init(word: VocabularyWord) {
        self.word = word
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
}
