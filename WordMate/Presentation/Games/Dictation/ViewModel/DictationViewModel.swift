//
//  DictationViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit

class DictationViewModel {
    private let gameDatas: [VocabularyWord]
    private var userResponses = [Question]()
    
    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
    
    var currentIndex = 0
    var totalWords: Int {
        get {
            return gameDatas.count
        }
    }
    
    var currentWord: VocabularyWord {
        gameDatas[currentIndex]
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
