//
//  MultipleChoiceViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

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

        view.backgroundColor = .systemBackground
        speechService.delegate = self
        setupButtons()
        setupSubviews()
        setupConstraints()
        setupGame()
    }
    
    // MARK: - Setup
    private func setupGame() {
        setupIndicator()
        setupWord()
        setupOptions()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex + 1) / Float(viewModel.totalWords)
    }
    
    private func setupWord() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
    }
    
    private func setupOptions() {
        options = viewModel.generateOptions()
        for (button, option) in zip(optionButtons, options) {
            button.setTitle(option.meaning, for: .normal)
        }
    }
    
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
    
    private func setupButtons() {
        optionButtons.enumerated().forEach { index, button in
            button.tag = index
            button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
        }
        
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        wordLabelView.speakerButton.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
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
        goToNextWord(isCorrect: selectedOption.isCorrect)
    }
    
    private func goToNextWord(isCorrect: Bool) {
        showFeedback(isCorrect: isCorrect)
        viewModel.appendUserResponse(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.wordLabelView.feedbackLabel.isHidden = true
            self.viewModel.currentIndex += 1
            
            // 게임 종료 여부 확인 후 진행
            if self.viewModel.currentIndex >= self.viewModel.totalWords {
                self.viewModel.goToGameResultVC(from: self, animated: true)
            } else {
                self.setupGame()
                self.optionButtons.forEach { $0.isEnabled = true }
            }
        }
    }
    
    private func showFeedback(isCorrect: Bool) {
        let feedbackMessage = isCorrect ? "정답 🎉" : "오답 💪"
        let feedbackColor = isCorrect ? UIColor.systemGreen : UIColor.systemRed
        wordLabelView.feedbackLabel.isHidden = false
        wordLabelView.feedbackLabel.text = feedbackMessage
        wordLabelView.feedbackLabel.textColor = feedbackColor
    }
    
    // MARK: - Layout
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
}

// MARK: - Delegate Methods
extension MultipleChoiceViewController: SpeechServiceDelegate {
    func speechDidStart() {
        DispatchQueue.main.async {
            self.wordLabelView.speakerButton.tintColor = .primaryOrange
        }
    }
    
    func speechDidFinish() {
        DispatchQueue.main.async {
            self.wordLabelView.speakerButton.tintColor = .systemGray3
        }
    }
}
