//
//  RepeatViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit

final class RepeatViewModel {
    
    // MARK: - Properties
    private let gameData: [VocabularyWord]
    private(set) var wordIndex = 0
    
    var currentIndex: Int {
        (wordIndex % gameData.count) + 1
    }
    
    var currentWord: VocabularyWord {
        gameData[wordIndex % gameData.count]
    }

    // MARK: - Game Status
    var progressText: String {
        return "\(currentIndex) / \(gameData.count)"
    }
    
    var progressValue: Float {
        return Float(currentIndex) / Float(gameData.count)
    }

    // MARK: - Initializer
    init(gameData: [VocabularyWord]) {
        self.gameData = gameData
    }
    
    // MARK: - Game State Management
    func incrementCurrentIndex() {
        wordIndex += 1
    }
}
