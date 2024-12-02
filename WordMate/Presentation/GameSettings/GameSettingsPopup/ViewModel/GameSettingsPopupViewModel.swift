//
//  GameSettingsPopupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class GameSettingsPopupViewModel {
    
    private var allWords: [VocabularyWord] = []
    private var gameSettings: GameSettings?

    func configureGame(words: [VocabularyWord], settings: GameSettings) {
        self.allWords = words
        self.gameSettings = settings
    }
    
    func configureWords() -> [VocabularyWord] {
        guard let setting = gameSettings else { return [] }
        var filterWords = allWords
        
        if setting.includeBookmarkWords {
            filterWords = filterWords.filter { $0.isLiked }
        }
        
        if setting.questionOrder == .random {
            filterWords.shuffle()
        }
        
        return filterWords
    }
    
    func goToMultipleChoiceVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let multipleChoiceVC = MultipleChoiceViewController(viewModel: MultipleChoiceViewModel(gameDatas: gameDatas))
        multipleChoiceVC.modalPresentationStyle = .overFullScreen
        viewController.present(multipleChoiceVC, animated: animated, completion: nil)
    }
}
