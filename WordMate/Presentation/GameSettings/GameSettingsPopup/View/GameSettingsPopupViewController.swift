//
//  GameSettingsPopupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit
import Then
import SnapKit

final class GameSettingsPopupViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: GameSettingsPopupViewModel
    private let popupView: GameSettingsPopupView
    
    // MARK: - Initializers
    init(viewModel: GameSettingsPopupViewModel) {
        self.viewModel = viewModel
        self.popupView = GameSettingsPopupView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .clear
        popupView.updateTitle(viewModel.title)
        setupSubviews()
        setupConstraints()
        setupButtonActions()
    }
    
    private func setupSubviews() {
           popupView.backAction = { [weak self] in self?.dismiss(animated: true) }
           popupView.startAction = { [weak self] in self?.startGame() }
           view.addSubview(popupView)
       }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupButtonActions() {
        popupView.groupSelectionButton.addTarget(self, action: #selector(groupSelectionButtonTapped), for: .touchUpInside)
        popupView.wordSelectionTypeButton.addTarget(self, action: #selector(wordSelectionButtonTapped), for: .touchUpInside)
        popupView.wordOrderButton.addTarget(self, action: #selector(wordOrderButtonTapped), for: .touchUpInside)
        popupView.wordCountButton.addTarget(self, action: #selector(countButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func groupSelectionButtonTapped() {
        viewModel.showGroupSelectionVC(from: self, animated: true) { [weak self] selectedGroup in
            guard let self = self, let group = selectedGroup else { return }
            self.popupView.groupSelectionButton.setDynamicLabelText(group.name)
            self.viewModel.configureWords(words: Array(group.words))
            self.popupView.updateStartButtonState(isEnabled: true)
        }
    }
    
    @objc private func wordSelectionButtonTapped() {
        viewModel.showQuestionSelectionVC(from: self, animated: true) { [weak self] isFavorite in
            guard let self = self, let isFavorite = isFavorite else { return }
            let title = isFavorite ? "즐겨찾기 한 단어" : "모든 단어"
            self.popupView.wordSelectionTypeButton.setDynamicLabelText(title)
        }
    }
    
    @objc private func wordOrderButtonTapped() {
        viewModel.showQuestionOrderVC(from: self, animated: true) { [weak self] order in
            guard let self = self, let order = order else { return }
            self.popupView.wordOrderButton.setDynamicLabelText(order.rawValue)
        }
    }
    
    @objc private func countButtonTapped() {
        viewModel.showQuestionCountVC(from: self, animated: true) { [weak self] count in
            guard let self = self, let count = count else { return }
            self.popupView.wordCountButton.setDynamicLabelText("\(count)개")
        }
    }
    
    // MARK: - Game Logic
    private func startGame() {
        let settings = viewModel.configureGameSettings()
        viewModel.configureGame(settings: settings)
        let gameData = viewModel.filterWords()
        transitionToGameScreen(gameData: gameData)
    }
    
    private func transitionToGameScreen(gameData: [VocabularyWord]) {
        guard let presentingVC = presentingViewController else { return }
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            switch self.viewModel.title {
            case "플래시카드":
                self.viewModel.navigateToFlashCardVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "사지선다":
                self.viewModel.navigateToMultipleChoiceVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "받아쓰기":
                self.viewModel.navigateToDictationVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "반복하기":
                self.viewModel.navigateToRepeatVC(from: presentingVC, gameDatas: gameData, animated: true)
            default:
                print("지원하지 않는 게임 모드입니다.")
            }
        }
    }
}
