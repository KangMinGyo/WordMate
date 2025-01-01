//
//  MultipleChoiceViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit
import SnapKit
import Then

final class MultipleChoiceViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MultipleChoiceViewModel
    private let speechService = SpeechService()
    private var options: [MultipleChoiceOption] = []
    
    private let gameStatusView = GameStatusView()
    private let wordLabelView = WordLabelView()
    private lazy var optionButtons: [UIButton] = createOptionButtons()
    
    private lazy var stackView = UIStackView(arrangedSubviews: optionButtons).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

    private let skipButton = UIButton().then {
        $0.setTitle("잘 모르겠어요", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    // MARK: - Initializers
    init(viewModel: MultipleChoiceViewModel) {
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
        speechService.delegate = self
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupButtonActions() {
        optionButtons.enumerated().forEach { index, button in
            button.tag = index
            button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
        }
        
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        wordLabelView.speakerButton.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
        self.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(wordLabelView)
        view.addSubview(stackView)
        view.addSubview(skipButton)
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

        stackView.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupGame() {
        updateGameStatusIndicator()
        updateWordLabel()
        updateOptionButtons()
    }
    
    private func updateGameStatusIndicator() {
        gameStatusView.indicatorLabel.text = viewModel.progressText
        gameStatusView.progressBar.progress = viewModel.progressValue
    }
    
    private func updateWordLabel() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
    }
    
    private func updateOptionButtons() {
        options = viewModel.generateOptions()
        for (button, option) in zip(optionButtons, options) {
            button.setTitle(option.meaning, for: .normal)
        }
    }
    
    // MARK: - Button Creation
    private func createOptionButtons() -> [UIButton] {
        return (1...4).map { _ in
            let button = UIButton(type: .system)
            button.tintColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            button.backgroundColor = .primaryOrange
            button.layer.cornerRadius = 20
            return button
        }
    }
    
    // MARK: - Actions
    @objc func speakerButtonTapped() {
        let text = viewModel.currentWord.name
        speechService.speak(text)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func choiceButtonTapped(_ sender: UIButton) {
        let selectedOption = options[sender.tag]
        optionButtons.forEach { $0.isEnabled = false }
        handleNextWord(isCorrect: selectedOption.isCorrect)
    }
    
    @objc private func skipButtonTapped() {
        handleNextWord(isCorrect: false)
    }
    
    private func handleNextWord(isCorrect: Bool) {
        displayFeedback(isCorrect: isCorrect)
        viewModel.appendUserResponse(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.wordLabelView.feedbackLabel.isHidden = true
            self.viewModel.incrementCurrentIndex()
            
            // 게임 종료 여부 확인 후 진행
            if self.viewModel.isGameComplete {
                self.viewModel.navigateToGameResultVC(from: self, animated: true)
            } else {
                self.setupGame()
                self.optionButtons.forEach { $0.isEnabled = true }
            }
        }
    }
    
    private func displayFeedback(isCorrect: Bool) {
        wordLabelView.feedbackLabel.isHidden = false
        wordLabelView.feedbackLabel.text = isCorrect ? "정답 🎉" : "오답 💪"
        wordLabelView.feedbackLabel.textColor = isCorrect ? .systemGreen : .systemRed
    }
}

// MARK: - SpeechServiceDelegate
extension MultipleChoiceViewController: SpeechServiceDelegate {
    func speechDidStart() {
        wordLabelView.speakerButton.tintColor = .primaryOrange
    }
    
    func speechDidFinish() {
        wordLabelView.speakerButton.tintColor = .systemGray3
    }
}
