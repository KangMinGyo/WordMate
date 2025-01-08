//
//  GameSettingsPopupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

final class GameSettingsPopupViewModel {
    
    // MARK: - Properties
    private var titleLabelText: String
    private var allWords: [VocabularyWord] = []
    private var includeBookmarkWords: Bool = false
    private var questionOrder: QuestionOrder = .sequential
    private var questionCount: Int = 20
    private var gameSettings: GameSettings?
    
    // MARK: - Computed Properties
    var title: String { titleLabelText }
    
    // MARK: - Initializer
    init(titleLabelText: String) {
        self.titleLabelText = titleLabelText
    }
    
    // MARK: - Configuration
    func configureWords(words: [VocabularyWord]) {
        self.allWords = words
    }
    
    func configureGame(settings: GameSettings) {
        self.gameSettings = settings
    }
    
    func configureGameSettings() -> GameSettings {
        return GameSettings(
            includeBookmarkWords: includeBookmarkWords,
            questionOrder: questionOrder,
            questionCount: questionCount
        )
    }
    
    // MARK: - Update Methods
    func updateBookmarkSetting(_ isFavorite: Bool) {
        self.includeBookmarkWords = isFavorite
    }
    
    func updateQuestionOrder(_ order: QuestionOrder) {
        self.questionOrder = order
    }
    
    func updateQuestionCount(_ count: Int) {
        self.questionCount = count
    }
    
    // MARK: - Filtering
    func filterWords() -> [VocabularyWord] {
        guard let setting = gameSettings else { return [] }
        
        // 북마크 여부
        var filteredWords = allWords
        if setting.includeBookmarkWords {
            filteredWords = filteredWords.filter { $0.isLiked }
        }
        
        // 단어 순서
        if setting.questionOrder == .random {
            filteredWords.shuffle()
        } else if setting.questionOrder == .reverse {
            filteredWords.reverse()
        }
        
        // 단어 개수만큼 return
        return Array(filteredWords.prefix(setting.questionCount))
    }
    
    // MARK: - Sheet Presentation
    private func presentSheet(
        from presentingVC: UIViewController,
        to presentedVC: UIViewController,
        height: CGFloat,
        animated: Bool
    ) {
        presentedVC.modalPresentationStyle = .pageSheet
        
        if let sheet = presentedVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in height })]
        }

        presentingVC.present(presentedVC, animated: animated, completion: nil)
    }
    
    func showGroupSelectionVC(from viewController: UIViewController, animated: Bool, onGroupSelected: @escaping (VocabularyGroup?) -> Void) {
        let groupSelectionViewModel = GroupSelectionViewModel(realmManager: RealmManager())
        let groupSelectionVC = GroupSelectionViewController(viewModel: groupSelectionViewModel)
        
        groupSelectionViewModel.onGroupSelected = { selectedGroup in
            onGroupSelected(selectedGroup)
        }
        
        presentSheet(from: viewController, to: groupSelectionVC, height: 250, animated: animated)
    }
    
    func showQuestionSelectionVC(from viewController: UIViewController, animated: Bool, onQuestionSelected: @escaping(Bool?) -> Void) {
        let questionSelectionViewModel = QuestionSelectionViewModel()
        let questionSelectionVC = QuestionSelectionViewController(viewModel: questionSelectionViewModel)
        
        questionSelectionViewModel.onQuestionSelected = { isFavorite in
            if let isFavorite = isFavorite {
                onQuestionSelected(isFavorite)
                self.updateBookmarkSetting(isFavorite)
            }
        }
        
        presentSheet(from: viewController, to: questionSelectionVC, height: 220, animated: animated)
    }
    
    func showQuestionOrderVC(from viewController: UIViewController, animated: Bool, onQuestionOrderSelected: @escaping(QuestionOrder?) -> Void) {
        let questionOrderViewModel = QuestionOrderViewModel()
        let questionOrderVC = QuestionOrderViewController(viewModel: questionOrderViewModel)
        
        questionOrderViewModel.onQuestionOrderSelected = { order in
            if let order = order {
                onQuestionOrderSelected(order)
                self.updateQuestionOrder(order)
            }
        }
        
        presentSheet(from: viewController, to: questionOrderVC, height: 250, animated: true)
    }
    
    func showQuestionCountVC(from viewController: UIViewController, animated: Bool, onCountConfirmed: @escaping(Int?) -> Void) {
        let questionCountViewModel = QuestionCountViewModel()
        let questionCountVC = QuestionCountViewController(viewModel: questionCountViewModel)

        questionCountViewModel.onCountConfirmed = { count in
            onCountConfirmed(count)
            self.updateQuestionCount(count)
        }
        
        presentSheet(from: viewController, to: questionCountVC, height: 220, animated: animated)
    }
    
    // MARK: - Game Navigation
    private func presentGameViewController(
        from presentingVC: UIViewController,
        viewController: UIViewController,
        animated: Bool
    ) {
        viewController.modalPresentationStyle = .overFullScreen
        presentingVC.present(viewController, animated: animated, completion: nil)
    }
    
    func navigateToFlashCardVC(from viewController: UIViewController, gameData: [VocabularyWord], animated: Bool) {
        let flashCardVC = FlashCardViewController(viewModel: FlashCardViewModel(gameData: gameData))
        presentGameViewController(from: viewController, viewController: flashCardVC, animated: animated)
    }
    
    func navigateToMultipleChoiceVC(from viewController: UIViewController, gameData: [VocabularyWord], animated: Bool) {
        let multipleChoiceVC = MultipleChoiceViewController(viewModel: MultipleChoiceViewModel(gameData: gameData))
        presentGameViewController(from: viewController, viewController: multipleChoiceVC, animated: animated)
    }

    func navigateToDictationVC(from viewController: UIViewController, gameData: [VocabularyWord], animated: Bool) {
        let dictationVC = DictationViewController(viewModel: DictationViewModel(gameData: gameData))
        presentGameViewController(from: viewController, viewController: dictationVC, animated: animated)
    }

    func navigateToRepeatVC(from viewController: UIViewController, gameData: [VocabularyWord], animated: Bool) {
        let repeatVC = RepeatViewController(viewModel: RepeatViewModel(gameData: gameData))
        presentGameViewController(from: viewController, viewController: repeatVC, animated: animated)
    }
}
