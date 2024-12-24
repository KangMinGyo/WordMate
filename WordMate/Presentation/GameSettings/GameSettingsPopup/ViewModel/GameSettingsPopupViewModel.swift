//
//  GameSettingsPopupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class GameSettingsPopupViewModel {
    
    private var titleLabelText: String
    private var allWords: [VocabularyWord] = []
    private var includeBookmarkWords: Bool = false
    private var questionOrder: QuestionOrder = .sequential
    private var questionCount: Int = 5
    private var gameSettings: GameSettings?
    
    var title: String {
        titleLabelText
    }
    
    init(titleLabelText: String) {
        self.titleLabelText = titleLabelText
    }
    
    func configureWords(words: [VocabularyWord]) {
        self.allWords = words
    }
    
    func configureGame(settings: GameSettings) {
        self.gameSettings = settings
    }
    
    func updateBookmarkSetting(_ isFavorite: Bool) {
        self.includeBookmarkWords = isFavorite
    }
    
    func updateQuestionOrder(_ order: QuestionOrder) {
        self.questionOrder = order
    }
    
    func updateQuestionCount(_ count: Int) {
        self.questionCount = count
    }
    
    func configureGameSettings() -> GameSettings {
        return GameSettings(
            includeBookmarkWords: includeBookmarkWords,
            questionOrder: questionOrder,
            questionCount: questionCount
        )
    }
    
    func filterWords() -> [VocabularyWord] {
        guard let setting = gameSettings else { return [] }
        print("ViewModel Game Setting : \(setting)")
        var filterWords = allWords
        
        if setting.includeBookmarkWords {
            filterWords = filterWords.filter { $0.isLiked }
        }
        
        if setting.questionOrder == .random {
            filterWords.shuffle()
        } else if setting.questionOrder == .reverse {
            filterWords.reverse()
        }
        
        let count = setting.questionCount
        if filterWords.count > count {
            filterWords = Array(filterWords.prefix(count))
        }
        
        return filterWords
    }
    
    func showGroupSelectionVC(from viewController: UIViewController, animated: Bool, onGroupSelected: @escaping (VocabularyGroup?) -> Void) {
        let groupSelectionViewModel = GroupSelectionViewModel(realmManager: RealmManager())
        let groupSelectionVC = GroupSelectionViewController(viewModel: groupSelectionViewModel)
        groupSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = groupSelectionVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 250
                })
            ]
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
                self.updateBookmarkSetting(isFavorite)
            }
        }
        
        let questionSelectionVC = QuestionSelectionViewController(viewModel: questionSelectionViewModel)
        questionSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = questionSelectionVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return 220
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
                self.updateQuestionOrder(order)
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
            self.updateQuestionCount(count)
        }
        
        viewController.present(questionCountVC, animated: animated, completion: nil)
    }
    
    func goToFlashCardVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let dictationVC = FlashCardViewController(viewModel: FlashCardViewModel(gameDatas: gameDatas))
        dictationVC.modalPresentationStyle = .overFullScreen
        viewController.present(dictationVC, animated: animated, completion: nil)
    }
    
    func goToMultipleChoiceVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let multipleChoiceVC = MultipleChoiceViewController(viewModel: MultipleChoiceViewModel(gameDatas: gameDatas))
        multipleChoiceVC.modalPresentationStyle = .overFullScreen
        viewController.present(multipleChoiceVC, animated: animated, completion: nil)
    }
    
    func goToDictationVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let dictationVC = DictationViewController(viewModel: DictationViewModel(gameDatas: gameDatas))
        dictationVC.modalPresentationStyle = .overFullScreen
        viewController.present(dictationVC, animated: animated, completion: nil)
    }
    
    func goToRepeatVC(from viewController: UIViewController, gameDatas: [VocabularyWord], animated: Bool) {
        let dictationVC = RepeatViewController(viewModel: RepeatViewModel(gameDatas: gameDatas))
        dictationVC.modalPresentationStyle = .overFullScreen
        viewController.present(dictationVC, animated: animated, completion: nil)
    }
}
