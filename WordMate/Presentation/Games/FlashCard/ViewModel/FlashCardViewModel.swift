//
//  FlashCardViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/17/24.
//

import Foundation

class FlashCardViewModel {
    private let gameDatas: [VocabularyWord]
    private var userResponses = [Question]()
    
    var wordIndex = 0
    
    var currentIndex: Int {
        (wordIndex % gameDatas.count) + 1
    }
    
    var words: [VocabularyWord] {
        gameDatas
    }
    
    var currentWord: VocabularyWord {
        gameDatas[wordIndex % gameDatas.count]
    }

    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
}
