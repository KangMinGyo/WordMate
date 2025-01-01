//
//  MultipleChoiceViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

final class MultipleChoiceViewModel {
    
    // MARK: - Properties
    private let gameData: [VocabularyWord]
    private var userResponses = [Question]()
    private(set) var currentIndex = 0

    var currentWord: VocabularyWord {
        gameData[currentIndex]
    }
    
    // MARK: - Game Status
    var progressText: String {
        return "\(currentIndex + 1) / \(gameData.count)"
    }
    
    var progressValue: Float {
        return Float(currentIndex + 1) / Float(gameData.count)
    }
    
    var isGameComplete: Bool {
        return currentIndex >= gameData.count
    }

    // MARK: - Initializer
    init(gameData: [VocabularyWord]) {
        self.gameData = gameData
    }
    
    // MARK: - Game State Management
    func incrementCurrentIndex() {
        currentIndex += 1
    }
    
    func generateOptions() -> [MultipleChoiceOption] {
        var options = [MultipleChoiceOption]()
        
        // 정답 생성
        options.append(MultipleChoiceOption(meaning: currentWord.meaning, isCorrect: true))
        
        // 오답 생성
        let incorrectWords = gameData.filter { $0.name != currentWord.name }.shuffled().prefix(3)
        for word in incorrectWords {
            options.append(MultipleChoiceOption(meaning: word.meaning, isCorrect: false))
        }
        return options.shuffled()
    }
    
    // MARK: - User Response Management
    func appendUserResponse(isCorrect: Bool) {
        userResponses.append(Question(word: currentWord, isCorrect: isCorrect))
    }
    
    // MARK: - Navigation
    func navigateToGameResultVC(from viewController: UIViewController, animated: Bool) {
        let gameResultVM = GameResultViewModel(questions: userResponses)
        let gameResultVC = GameResultViewController(viewModel: gameResultVM)
        gameResultVC.modalPresentationStyle = .overFullScreen
        
        dismissAndPresent(from: viewController, to: gameResultVC, animated: animated)
    }
    
    private func dismissAndPresent(from currentVC: UIViewController, to nextVC: UIViewController, animated: Bool) {
        guard let presentingVC = currentVC.presentingViewController else { return }
        currentVC.dismiss(animated: animated) {
            presentingVC.present(nextVC, animated: animated)
        }
    }
}
