//
//  MultipleChoiceViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

class MultipleChoiceViewModel {
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
    
    func generateOptions() -> [MultipleChoiceOption] {
        var options = [MultipleChoiceOption]()
        
        // 정답 생성
        options.append(MultipleChoiceOption(meaning: currentWord.meaning, isCorrect: true))
        
        // 오답 생성
        let incorrectWords = gameDatas.filter { $0.name != currentWord.name }.shuffled().prefix(3)
        for word in incorrectWords {
            options.append(MultipleChoiceOption(meaning: word.meaning, isCorrect: false))
        }
        return options.shuffled()
    }
    
    func appendUserResponse(isCorrect: Bool, userAnswer: String) {
        userResponses.append(Question(word: currentWord, isCorrect: isCorrect))
    }
    
    func printUserResponses() {
        print("userResponses: \(userResponses)")
    }
    
    func goToGameResultVC(from viewController: UIViewController, animated: Bool) {
        let gameResultVC = GameResultViewController(viewModel: GameResultViewModel(questions: userResponses))
        gameResultVC.modalPresentationStyle = .overFullScreen
        
        // dismiss 후 화면 전환
        guard let presentingVC = viewController.presentingViewController else { return }
        viewController.dismiss(animated: true) {
            presentingVC.present(gameResultVC, animated: true)
        }
    }
}
