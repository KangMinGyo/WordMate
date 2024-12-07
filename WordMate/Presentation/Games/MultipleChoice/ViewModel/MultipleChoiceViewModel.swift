//
//  MultipleChoiceViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import Foundation

class MultipleChoiceViewModel {
    private let gameDatas: [VocabularyWord]
    var currentIndex = 0
    var totalWords: Int {
        get {
            return gameDatas.count + 1
        }
    }
    
    var currentWord: String {
        gameDatas[currentIndex].name
    }
    
    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
}
