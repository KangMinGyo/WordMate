//
//  DictationViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import Foundation

class DictationViewModel {
    private let gameDatas: [VocabularyWord]
    private var userResponses = [Question]()
    
    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
}
