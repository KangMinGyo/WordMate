//
//  DictationViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit
import SnapKit
import Then

final class DictationViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: DictationViewModel
    private let speechService = SpeechService()
    private let gameStatusView = GameStatusView()
    private let wordLabelView = WordLabelView()
    
    private lazy var dictationTextField = UITextField().then {
        $0.placeholder = "단어의 철자를 입력하세요."
        $0.borderStyle = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addPadding()

    }
    
    // MARK: - Initializers
    init(viewModel: DictationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGame()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        dictationTextField.delegate = self
        speechService.delegate = self
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupButtonActions() {
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        wordLabelView.speakerButton.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(wordLabelView)
        view.addSubview(dictationTextField)
    }

    private func setupConstraints() {
        gameStatusView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
        
        wordLabelView.snp.makeConstraints {
            $0.top.equalTo(gameStatusView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
        
        dictationTextField.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
    }
    
    private func setupGame() {
        updateGameStatusIndicator()
        updateWordLabel()
    }
    
    private func updateGameStatusIndicator() {
        gameStatusView.indicatorLabel.text = viewModel.progressText
        gameStatusView.progressBar.progress = viewModel.progressValue
    }
    
    private func updateWordLabel() {
        wordLabelView.wordLabel.text = viewModel.currentWord.meaning
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func speakerButtonTapped() {
        let text = viewModel.currentWord.name
        speechService.speak(text)
    }
    
    private func handleNextWord(isCorrect: Bool, userAnswer: String) {
        displayFeedback(isCorrect: isCorrect)
        resetTextField()
        
        viewModel.appendUserResponse(isCorrect: isCorrect, userAnswer: userAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.wordLabelView.feedbackLabel.isHidden = true
            self.viewModel.incrementCurrentIndex()
            
            // 게임 종료 여부 확인 후 진행
            if self.viewModel.isGameComplete {
                self.viewModel.navigateToGameResultVC(from: self, animated: true)
            } else {
                self.setupGame()
            }
        }
    }
    
    private func displayFeedback(isCorrect: Bool) {
        wordLabelView.feedbackLabel.isHidden = false
        wordLabelView.feedbackLabel.text = isCorrect ? "정답 🎉" : "오답 💪"
        wordLabelView.feedbackLabel.textColor = isCorrect ? .systemGreen : .systemRed
        
        // 정답이 틀린 경우 단어 보여주기
        if !isCorrect {
            wordLabelView.wordLabel.text = viewModel.currentWord.name
        }
    }
    
    private func resetTextField() {
        dictationTextField.text = ""
    }
}

// MARK: - UITextFieldDelegate
extension DictationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userAnswer = dictationTextField.text?.lowercased() else { return false }
        let isCorrect = viewModel.currentWord.name.lowercased() == userAnswer
        handleNextWord(isCorrect: isCorrect, userAnswer: userAnswer)
        return true
    }
}

// MARK: - SpeechServiceDelegate
extension DictationViewController: SpeechServiceDelegate {
    func speechDidStart() {
        wordLabelView.speakerButton.tintColor = .primaryOrange
    }
    
    func speechDidFinish() {
        wordLabelView.speakerButton.tintColor = .systemGray3
    }
}
