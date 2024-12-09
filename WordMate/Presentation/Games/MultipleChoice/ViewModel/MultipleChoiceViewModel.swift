//
//  MultipleChoiceViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

class MultipleChoiceViewModel {
    private let gameDatas: [VocabularyWord]

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
    
    func generateOptions() -> [MultipleChoiceOption] {
        var options = [MultipleChoiceOption]()
        
        // 정답
        options.append(MultipleChoiceOption(meaning: currentWord.meaning, isCorrect: true))
        
        // 오답
        let incorrectWords = gameDatas.filter { $0.name != currentWord.name }.shuffled().prefix(3)
        for word in incorrectWords {
            options.append(MultipleChoiceOption(meaning: word.meaning, isCorrect: false))
        }
        return options.shuffled()
    }
    
    func goToGameResultVC(from viewController: UIViewController, animated: Bool) {
        let gameResultVC = GameResultViewController()
        gameResultVC.modalPresentationStyle = .overFullScreen
        viewController.present(gameResultVC, animated: animated, completion: nil)
    }
}
