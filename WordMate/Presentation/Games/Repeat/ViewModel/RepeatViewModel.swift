//
//  RepeatViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit

class RepeatViewModel {
    private let gameDatas: [VocabularyWord]
    
    var wordIndex = 0
    
    var currentIndex: Int {
        (wordIndex % gameDatas.count) + 1
    }
    
    var totalWords: Int {
        gameDatas.count
    }
    
    var currentWord: VocabularyWord {
        gameDatas[wordIndex % gameDatas.count]
    }

    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
}
