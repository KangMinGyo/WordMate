//
//  FlashCardViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/17/24.
//

import UIKit

class FlashCardViewModel {
    private let gameDatas: [VocabularyWord]
    private var userResponses = [Question]()
    
    var currentIndex = 0
    var totalWords: Int {
        gameDatas.count
    }
    
    var words: [VocabularyWord] {
        gameDatas
    }
    
    var currentWord: VocabularyWord {
        gameDatas[currentIndex]
    }

    init(gameDatas: [VocabularyWord]) {
        self.gameDatas = gameDatas
    }
    
    func appendUserResponse(isCorrect: Bool) {
        userResponses.append(Question(word: currentWord, isCorrect: isCorrect))
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
