//
//  MultipleChoiceViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import Foundation

class MultipleChoiceViewModel {
    private let gameDatas: [VocabularyWord]
    var currentIndex = 1
    var totalWords: Int {
        get {
            return gameDatas.count
        }
    }
    
    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
    
    func printGameDatas() {
        print(gameDatas)
    }
}
