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
    
    // MARK: - ViewModel
    let viewModel: GameSettingsPopupViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        popupView.titleLabel.text = viewModel.title
        setupSubviews()
        setupConstraints()
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        popupView.groupSelectionButton.addTarget(self, action: #selector(groupSelectionButtonTapped), for: .touchUpInside)
        popupView.wordSelectionTypeButton.addTarget(self, action: #selector(wordSelectionButtonTapped), for: .touchUpInside)
        popupView.wordOrderButton.addTarget(self, action: #selector(wordOrderButtonTapped), for: .touchUpInside)
        popupView.wordCountButton.addTarget(self, action: #selector(countButtonTapped), for: .touchUpInside)
    }
    
    @objc func groupSelectionButtonTapped() {
        viewModel.showGroupSelectionVC(from: self, animated: true) { selectedGroup in
            if let group = selectedGroup {
                self.popupView.groupSelectionButton.setDynamicLabelText(group.name)
                self.viewModel.configureWords(words: Array(group.words))
                // 그룹 선택 -> 버튼 활성화
                self.popupView.updateStartButtonState(isEnabled: true)
            }
        }
    }
    
    @objc func wordSelectionButtonTapped() {
        viewModel.showQuestionSelectionVC(from: self, animated: true) { isFavorite in
            if let isFavorite = isFavorite {
                let title = isFavorite ? "즐겨찾기 한 단어" : "모든 단어"
                self.popupView.wordSelectionTypeButton.setDynamicLabelText(title)
            }
        }
    }
    
    @objc func wordOrderButtonTapped() {
        viewModel.showQuestionOrderVC(from: self, animated: true) { order in
            if let order = order {
                let title = order.rawValue
                self.popupView.wordOrderButton.setDynamicLabelText(title)
            }
        }
    }
    
    
    @objc func countButtonTapped() {
        viewModel.showQuestionCountVC(from: self, animated: true) { count in
            if let count = count {
                self.popupView.wordCountButton.setDynamicLabelText("\(count)개")
            }
        }
    }
    
    private func setupSubviews() {
        popupView.backAction = { [weak self] in
            self?.backButtonTapped()
        }
        
        popupView.startAction = { [weak self] in
            self?.startButtonTapped()
        }
        
        view.addSubview(popupView)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func startButtonTapped() {
        // GameSettings 생성
        let settings = viewModel.configureGameSettings()
        viewModel.configureGame(settings: settings)
        
        // 게임 데이터 구성
        let gameData = viewModel.filterWords()
        
        // dismiss 후 화면 전환
        guard let presentingVC = self.presentingViewController else { return }
        dismiss(animated: true) { [weak self] in
            let title = self?.viewModel.title
            switch title {
            case "플래시카드":
                self?.viewModel.goToFlashCardVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "사지선다":
                self?.viewModel.goToMultipleChoiceVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "받아쓰기":
                self?.viewModel.goToDictationVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "반복하기":
                self?.viewModel.goToRepeatVC(from: presentingVC, gameDatas: gameData, animated: true)
            default:
                print("지원하지 않는 게임 모드입니다.")
            }
        }
    }
}
