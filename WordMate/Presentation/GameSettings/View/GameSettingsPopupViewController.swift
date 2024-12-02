//
//  GameSettingsPopupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit

class GameSettingsPopupViewController: UIViewController {
    
    private let popupView: GameSettingsPopupView
    
    let words: [VocabularyWord] = [
        VocabularyWord(name: "Apple1", meaning: "사과1"),
        VocabularyWord(name: "Apple2", meaning: "사과2"),
        VocabularyWord(name: "Apple3", meaning: "사과3"),
        VocabularyWord(name: "Apple4", meaning: "사과4"),
        VocabularyWord(name: "Apple5", meaning: "사과5"),
    ]
    
    //MARK: - ViewModel
    let viewModel: GameSettingsPopupViewModel
    
    // MARK: - Initializers
    init(viewModel: GameSettingsPopupViewModel, title: String) {
        self.viewModel = viewModel
        self.popupView = GameSettingsPopupView(title: title)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupSubviews()
        setupConstraints()
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
        let settings = GameSettings(
            includeBookmarkWords: false,
            questionOrder: .sequential,
            questionCount: 10
        )
        
        // 게임 데이터 구성
        viewModel.configureGame(words: words, settings: settings)
        let gameData = viewModel.configureWords()
        
        // dismiss 후 화면 전환
        guard let presentingVC = self.presentingViewController else { return }
        dismiss(animated: true) { [weak self] in
            self?.viewModel.goToMultipleChoiceVC(from: presentingVC, gameDatas: gameData, animated: true)
        }
    }
}
