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
    
    func configureWords(words: [VocabularyWord]) {
        self.allWords = words
    }

    func configureGame(settings: GameSettings) {
        self.gameSettings = settings
    }
    
    func filterWords() -> [VocabularyWord] {
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
    
    func showGroupSelectionVC(from viewController: UIViewController, animated: Bool, onGroupSelected: @escaping (VocabularyGroup?) -> Void) {
        let groupSelectionViewModel = GroupSelectionViewModel(realmManager: RealmManager())
        let groupSelectionVC = GroupSelectionViewController(viewModel: groupSelectionViewModel)
        groupSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = groupSelectionVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        groupSelectionViewModel.onGroupSelected = { selectedGroup in
            onGroupSelected(selectedGroup)
        }
        
        viewController.present(groupSelectionVC, animated: animated, completion: nil)
    }
    
    func showQuestionCountVC(from viewController: UIViewController, animated: Bool, onCountConfirmed: @escaping(Int?) -> Void) {
        let questionCountViewModel = QuestionCountViewModel()
        let questionCountVC = QuestionCountViewController(viewModel: questionCountViewModel)
        questionCountVC.modalPresentationStyle = .pageSheet
        
        if let sheet = questionCountVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 220
                })
            ]
        }
        
        questionCountViewModel.onCountConfirmed = { count in
            onCountConfirmed(count)
        }
        
        viewController.present(questionCountVC, animated: animated, completion: nil)
    }
    
    func goToMultipleChoiceVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let multipleChoiceVC = MultipleChoiceViewController(viewModel: MultipleChoiceViewModel(gameDatas: gameDatas))
        multipleChoiceVC.modalPresentationStyle = .overFullScreen
        viewController.present(multipleChoiceVC, animated: animated, completion: nil)
    }
}
