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
    
    func showQuestionSelectionVC(from viewController: UIViewController, animated: Bool, onQuestionSelected: @escaping(Bool?) -> Void) {
        let questionSelectionViewModel = QuestionSelectionViewModel()
        
        questionSelectionViewModel.onQuestionSelected = { isFavorite in
            if let isFavorite = isFavorite {
                onQuestionSelected(isFavorite)
            }
        }
        
        let questionSelectionVC = QuestionSelectionViewController(viewModel: questionSelectionViewModel)
        questionSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = questionSelectionVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 200
                })
            ]
        }
        viewController.present(questionSelectionVC, animated: animated, completion: nil)
    }
    
    func showQuestionOrderVC(from viewController: UIViewController, animated: Bool, onQuestionOrderSelected: @escaping(QuestionOrder?) -> Void) {
        let questionOrderViewModel = QuestionOrderViewModel()
        
        questionOrderViewModel.onQuestionOrderSelected = { order in
            if let order = order {
                onQuestionOrderSelected(order)
            }
        }
        
        let questionOrderVC = QuestionOrderViewController(viewModel: questionOrderViewModel)
        questionOrderVC.modalPresentationStyle = .pageSheet
        
        if let sheet = questionOrderVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 250
                })
            ]
        }
        viewController.present(questionOrderVC, animated: animated, completion: nil)
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
