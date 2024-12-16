//
//  RepeatViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit

class RepeatViewModel {
    private let gameDatas: [VocabularyWord]
    private var userResponses = [Question]()
    
    var currentIndex = 0
    var totalWords: Int {
        get {
            return gameDatas.count
        }
    }
    
    var currentWord: VocabularyWord {
        gameDatas[currentIndex]
    }

    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
}
