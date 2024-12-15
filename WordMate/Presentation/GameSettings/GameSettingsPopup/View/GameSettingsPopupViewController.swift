//
//  GameSettingsPopupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit

final class GameSettingsPopupViewController: UIViewController {
    
    private let popupView: GameSettingsPopupView
    
    //MARK: - ViewModel
    let viewModel: GameSettingsPopupViewModel
    
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
        popupView.wordSelectionTypeButton.setTitle("모든 단어", for: .normal)
        popupView.wordOrderButton.setTitle("순서대로", for: .normal)
        
        popupView.groupSelectionButton.addTarget(self, action: #selector(groupSelectionButtonTapped), for: .touchUpInside)
        popupView.wordSelectionTypeButton.addTarget(self, action: #selector(wordSelectionButtonTapped), for: .touchUpInside)
        popupView.wordOrderButton.addTarget(self, action: #selector(wordOrderButtonTapped), for: .touchUpInside)
        popupView.wordCountButton.addTarget(self, action: #selector(countButtonTapped), for: .touchUpInside)
    }
    
    @objc func groupSelectionButtonTapped() {
        viewModel.showGroupSelectionVC(from: self, animated: true) { selectedGroup in
            if let group = selectedGroup {
                self.popupView.groupSelectionButton.setTitle("\(group.name)", for: .normal)
                let wordsArray = Array(group.words)
                self.viewModel.configureWords(words: wordsArray)
                print("선택된 그룹: \(group.name)")
            } else {
                print("그룹 선택 x")
            }
        }
    }
    
    @objc func wordSelectionButtonTapped() {
        viewModel.showQuestionSelectionVC(from: self, animated: true) { isFavorite in
            if let isFavorite = isFavorite {
                let title = isFavorite ? "즐겨찾기 한 단어" : "모든 단어"
                self.popupView.wordSelectionTypeButton.setTitle("\(title)", for: .normal)
            }
        }
    }
    
    @objc func wordOrderButtonTapped() {
        viewModel.showQuestionOrderVC(from: self, animated: true) { order in
            if let order = order {
                let title = order.rawValue
                self.popupView.wordOrderButton.setTitle("\(title)", for: .normal)
            }
        }
    }
    
    
    @objc func countButtonTapped() {
        viewModel.showQuestionCountVC(from: self, animated: true) { count in
            if let count = count {
                self.popupView.wordCountButton.setTitle("\(count)", for: .normal)
            }
        }
    }
    
    private func setupSubviews() {
        popupView.cancelAction = { [weak self] in
            self?.handleCancel()
        }
        
        popupView.startAction = { [weak self] in
            self?.handleStart()
        }
        
        view.addSubview(popupView)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func handleStart() {
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
            case "사지선다":
                self?.viewModel.goToMultipleChoiceVC(from: presentingVC, gameDatas: gameData, animated: true)
            case "받아쓰기":
                self?.viewModel.goToDictationVC(from: presentingVC, gameDatas: gameData, animated: true)
            default:
                print("지원하지 않는 게임 모드입니다.")
            }
        }
    }
}
